// SPDX-License-Identifier: GPL-2.0-or-later
/*
 * libiio - AD9361 IIO streaming example
 *
 * Copyright (C) 2014 IABG mbH
 * Author: Michael Feilen <feilen_at_iabg.de>
 **/

#include <stdint.h>
#include <string.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <float.h>
#include <math.h>
#include <iio.h>
#include <errno.h> // EAGAIN
#include <assert.h>
#include "pluto_iio.h"
 
 /************************************************************************/
/*     Compile-time options                                             */
/************************************************************************/
// IIO buf size
#define BUF_SIZE_MS  1

/************************************************************************/
/*     helper macros                                                    */
/************************************************************************/

#define MHZ(x) ((long long)(x*1000000LL))
#define GHZ(x) ((long long)(x*1000000000.+0.5))
#define PIPELINE_LEN 3u     // >= IIO buffer pipeline size. Skip buffers after LO change

#define MAX(x,y)    ((x)>(y) ? (x):(y))
#define MIN(x,y)    ((x)<(y) ? (x):(y))
#define ABS( x )    ( (x)>=0?(x):-(x) )

typedef struct
{
    unsigned change_iter;
    int lo_mhz;
    int num_channels_enabled;
    int channels_mask;
    struct 
    {
        int enabled;
        int bw_mhz;
        int fs_mhz;
        struct iio_channel* iio_ch;         // 'phy' channel "ad9361-phy"
        struct iio_channel* iio_stream_i;   // 'streaming' channel "cf-ad9361-lpc"
        struct iio_channel* iio_stream_q;
    } ch[2];
} ad936x_state_t;


ad936x_rx_limits_t g_rx_limit;
ad936x_state_t g_rx;


/* IIO structs required for streaming */
static struct iio_context *g_iio_device   = NULL;
static struct iio_buffer  *rxbuf = NULL;
static int g_rxbuf_blocking_mode;



static int init_iio_device_context()
{
    if (!g_iio_device)
    {
#ifdef _WIN32
        g_iio_device = iio_create_context_from_uri("ip:192.168.2.1");   // much faster than "ip:pluto"
        if (!g_iio_device)
        {
            g_iio_device = iio_create_context_from_uri("ip:pluto");
            if (!g_iio_device)
            {
                g_iio_device = iio_create_context_from_uri("ip:192.168.3.1");
            }
        }
#else
    g_iio_device = iio_create_default_context(); // pluto
    if (!g_iio_device)
    {
        // Raspberry Pi ?
        g_iio_device = iio_create_context_from_uri("ip:pluto.local");
    }
#endif
    }
    return !!g_iio_device;
}

/* cleanup and exit */
void iio_shutdown()
{
    int ch;
	printf("* Destroying buffers\n");
	if (rxbuf) { iio_buffer_destroy(rxbuf); rxbuf = NULL;}

	printf("* Disabling streaming channels\n");
    for (ch = 0; ch < 2; ch++)
    {
        if (g_rx.ch[ch].iio_stream_i)
        {
            iio_channel_disable(g_rx.ch[ch].iio_stream_i);
            g_rx.ch[ch].iio_stream_i = NULL;
        }
        if (g_rx.ch[ch].iio_stream_q)
        {
            iio_channel_disable(g_rx.ch[ch].iio_stream_q);
            g_rx.ch[ch].iio_stream_q = NULL;
        }
    }

	printf("* Destroying context\n");
	if (g_iio_device) { iio_context_destroy(g_iio_device); g_iio_device = NULL;}
}

void ABOCT(char * message)
{
    char str[256];
    iio_strerror(errno, str, sizeof(str));
    fprintf(stderr, "ERROR: %s errno = %d (%s)\n", message, errno, str);
    iio_shutdown();
    exit(0);
}

/* check return value of attr_write function */
static void errchk(int v, const char* what) {
	 if (v < 0) { fprintf(stderr, "Error %d writing to channel \"%s\"\nvalue may not be supported.\n", v, what); ABOCT(""); }
}

/* write attribute: long long int */
static void wr_ch_lli(struct iio_channel *chn, const char* what, long long val)
{
	errchk(iio_channel_attr_write_longlong(chn, what, val), what);
}

static int wr_ch_lli_unsafe(struct iio_channel *chn, const char* what, long long val)
{
    int err = iio_channel_attr_write_longlong(chn, what, val);
    if (err)
    {
        char str[256];
        iio_strerror(err,str,sizeof(str));
        fprintf(stderr, "error %d writing value %lld err=(%s)\n", err, val, str);
    }
    return !err;
}

/* write attribute: string */
static void wr_ch_str(struct iio_channel *chn, const char* what, const char* str)
{
	errchk((int)iio_channel_attr_write(chn, what, str), what);
}

/* helper function generating channel names */
static char* get_ch_name(const char* type, int id)
{
    static char tmpstr[64];
    snprintf(tmpstr, sizeof(tmpstr), "%s%d", type, id);
	return tmpstr;
}

/* returns ad9361 phy device */
static struct iio_device* get_ad9361_phy(void)
{
	return iio_context_find_device(g_iio_device, "ad9361-phy");
}

/* finds AD9361 streaming IIO devices */
static struct iio_device * get_ad9361_stream_dev(enum iodev d)
{
    return iio_context_find_device(g_iio_device, d==RX?"cf-ad9361-lpc":"cf-ad9361-dds-core-lpc");
}

/* finds AD9361 streaming IIO channels */
static bool get_ad9361_stream_ch(enum iodev d, struct iio_device *dev, int chid, struct iio_channel **chn)
{
    char * name = get_ch_name("voltage", chid);
	*chn = iio_device_find_channel(dev, name, d == TX);

	if (!*chn)
		*chn = iio_device_find_channel(dev, get_ch_name("altvoltage", chid), d == TX);
	return *chn != NULL;
}

/* finds AD9361 phy IIO configuration channel with id chid */
static struct iio_channel * get_phy_chan(enum iodev d, int chid)
{
    return iio_device_find_channel(get_ad9361_phy(), get_ch_name("voltage", chid), TX == d); 
}

/* finds AD9361 local oscillator IIO configuration channels */
static bool get_lo_chan(enum iodev d, struct iio_channel **chn)
{
    static struct iio_channel * cache[2];
	switch (d) 
    {
	 // LO chan is always output, i.e. true
	case RX: 
        if (!cache[0])
            cache[0] = iio_device_find_channel(get_ad9361_phy(), "altvoltage0", true); 
        *chn = cache[0]; 
        return *chn != NULL;
	case TX: 
        if (!cache[1])
            cache[1] = iio_device_find_channel(get_ad9361_phy(), "altvoltage1", true);
        *chn = cache[1];
        return *chn != NULL;

        //*chn = iio_device_find_channel(get_ad9361_phy(), "altvoltage1", true); return *chn != NULL;
    default: return false;
    }
}

/* applies streaming configuration through IIO */
static bool cfg_ad9361_streaming_ch(int ch_num, const ad936x_rx_channel_config* cfg)
{
    struct iio_channel* chn = g_rx.ch[ch_num].iio_ch;
	wr_ch_str(chn, "rf_port_select", "A_BALANCED");
	wr_ch_lli(chn, "rf_bandwidth", MHZ(cfg->bw_mhz));
	wr_ch_lli(chn, "sampling_frequency", MHZ(cfg->fs_mhz));
	return true;
}

int set_gain_db(int ch_num, int gain_db)
{
    struct iio_channel* chn = g_rx.ch[ch_num].iio_ch;
    if (!wr_ch_lli_unsafe(chn, "hardwaregain", gain_db))
    {
        printf("ERROR bad gain %d\n", (int)gain_db);
        return 0;
    }
    return 1;
}

volatile ad936x_rx_limits_t * sdr_get_limits()
{
    ad936x_rx_limits_t * limit = &g_rx_limit;
    memset(limit, 0, sizeof(*limit));

    if (init_iio_device_context())
    {
        struct iio_channel* chn = NULL;
        char str[111];
        int ch, step;
        if (get_lo_chan(RX, &chn))
        {
            if (iio_channel_attr_read(chn, "frequency_available", str, sizeof(str)) > 0)
            {
                sscanf(str, "[%lld %d %lld]", &limit->lo_hz[0], &step, &limit->lo_hz[1]);
                limit->lo_mhz.min = (int)((limit->lo_hz[0] + 1000000 - 1) / 1000000);
                limit->lo_mhz.max = (int)(limit->lo_hz[1] / 1000000);
            }
        }

        for (ch = 0; ch < 2; ch++)
        {
            chn = get_phy_chan(RX, ch);
            if (chn)
            {
                limit->ch[ch].available = 1;
                if (iio_channel_attr_read(chn, "hardwaregain_available", str, sizeof(str)) > 0)
                {
                    sscanf(str, "[%d %d %d]", &limit->ch[ch].gain_db.min, &step, &limit->ch[ch].gain_db.max);
                }
                if (iio_channel_attr_read(chn, "rf_bandwidth_available", str, sizeof(str)) > 0)
                {
                    sscanf(str, "[%d %d %d]", &limit->ch[ch].bw_hz.min, &step, &limit->ch[ch].bw_hz.max);
                }
                if (iio_channel_attr_read(chn, "sampling_frequency_available", str, sizeof(str)) > 0)
                {
                    sscanf(str, "[%d %d %d]", &limit->ch[ch].fs_hz.min, &step, &limit->ch[ch].fs_hz.max);
                }
            }
        }
        return limit;
    }
    return NULL;
}

void sdr_update_rx_gain_available()
{
    ad936x_rx_limits_t* limit = &g_rx_limit;
    struct iio_channel* chn = NULL;
    char str[111];
    int ch, step;
    for (ch = 0; ch < 2; ch++)
    {
        chn = get_phy_chan(RX, ch);
        if (chn)
        {
            limit->ch[ch].available = 1;
            if (iio_channel_attr_read(chn, "hardwaregain_available", str, sizeof(str)) > 0)
            {
                sscanf(str, "[%d %d %d]", &limit->ch[ch].gain_db.min, &step, &limit->ch[ch].gain_db.max);
            }
        }
    }
}

int set_lo_freq_mhz(enum iodev type, unsigned mhz)
{
    struct iio_channel* chn = NULL;
    if (!get_lo_chan(type, &chn))
    {
        printf("ERROR get_lo_chan\n");
        return 0;
    }
    if (!wr_ch_lli_unsafe(chn, "frequency", mhz * 1000000LL))
    {
        printf("ERROR bad frequency \n");
        return 0;
    }
    //sdr_get_limits();
    sdr_update_rx_gain_available();
    return 1;
}

int channel_attr_print_cb(struct iio_channel *chn, const char *attr, const char *val, size_t len, void *d)
{
    (void)chn; (void)d; (void)len;
    printf("\t\t\t%s = %s\n", attr, val);
    return 0;
}

int device_attr_print_cb(struct iio_device *dev, const char *attr, const char *value, size_t len, void *d)
{
    (void)dev; (void)d; (void)len;
    printf("\t\t%s = %s\n", attr, value);
    return 0;
}

// https://analogdevicesinc.github.io/libiio/master/libiio/index.html#code_model
void iio_info()
{
    int i;
    assert(g_iio_device);
    printf("IIO context: \n\tname = %s\n\tdesc = %s\n\t%d attributes\n\t%d devices\n", iio_context_get_name(g_iio_device), iio_context_get_description(g_iio_device), iio_context_get_attrs_count(g_iio_device), iio_context_get_devices_count(g_iio_device));
    int attrs_count = iio_context_get_attrs_count(g_iio_device);
    const char * attr_name, * attr_val;
    for (i = 0; i < attrs_count; i++)
    {
        if (iio_context_get_attr(g_iio_device, i, &attr_name, &attr_val))
        {
            printf("ERROR: context_get_attr()\n");
            return;
        }
        printf("\tattr name = %s val = %s\n", attr_name, attr_val);
    }

    int devices_count = iio_context_get_devices_count(g_iio_device);
    for (i = 0; i < devices_count; i++)
    {
        struct iio_device *dev;
        printf("\nDevice %d\n", i);
        dev = iio_context_get_device(g_iio_device, i);
        if (!dev)
        {
            printf("ERROR: iio_context_get_device()\n");
            return;
        }
        printf("\tid = %s\n\tname = %s\n\ttrigger = %s\n\t%d attributes\n\t%d buffer attributes\n\t%d channels\n", 
            iio_device_get_id(dev), iio_device_get_name(dev), iio_device_is_trigger(dev)?"tes":"no", iio_device_get_attrs_count(dev), iio_device_get_buffer_attrs_count(dev), iio_device_get_channels_count(dev));
        printf("\tDevice attributes:\n");
        iio_device_attr_read_all(dev, device_attr_print_cb, NULL);
        printf("\tDevice debug attributes:\n");
        iio_device_debug_attr_read_all(dev, device_attr_print_cb, NULL);
        printf("\tDevice buffer attributes:\n");
        iio_device_buffer_attr_read_all(dev, device_attr_print_cb, NULL);

        int ch, channels_count = iio_device_get_channels_count(dev);
        for (ch = 0; ch < channels_count; ch++)
        {
            struct iio_channel *chan;
            chan = iio_device_get_channel(dev, ch);
            if (!chan)
            {
                printf("ERROR: iio_device_get_channel()\n");
                return;
            }
            printf("\n\tChannel %d\n", ch);
            printf("\t\tid = %s\n\t\tname = %s\n\t\t%d attributes\n\t\tenabled = %d\n\t\tdirection = %s\n", 
                iio_channel_get_id(chan), iio_channel_get_name(chan), iio_channel_get_attrs_count(chan), iio_channel_is_enabled(chan), iio_channel_is_output(chan)?"output":"input");
            printf("\t\tChannel attributes:\n");
            iio_channel_attr_read_all(chan, channel_attr_print_cb, NULL); 
        }
    }
    fflush(stdout);
    iio_context_destroy(g_iio_device);
}

// Manual AGC:
// ADC provides 12 bits: [-2048..2047] or [0x7ff..-0x800]
// - Decrease gain in case of cliping
// - Increase gain if signal below specified threshold
#define MIN_DESIRED_LEVEL 0x400
int v_sat_count(const short *v, int n)
{
    int i, sat_count = 0, max = 0;
    for (i = 0; i < n; i++)
    {
        sat_count += (v[i] >=  2047);
        sat_count += (v[i] <= -2048);
        max = MAX(max, ABS(v[i]));
    }
    if (sat_count > 0)
    {
        if (sat_count > n / 64)
        {
            if (sat_count > n / 32)
            {
                if (sat_count > n / 16)
                {
                    if (sat_count > n / 8)
                    {
                        return -30;
                    }
                    return -20;
                }
                return -10;
            }
            return -3;
        }
        return -1;
    }
    if (max < MIN_DESIRED_LEVEL)
    {
        int gain_db = 1 - (int)(10*log10f((float)max/MIN_DESIRED_LEVEL));
        return gain_db;
    }
    return 0;
}

int v_sat_count_lite(const short* v, int n)
{
    int i, sat_count = 0, max = 0;
    for (i = 0; i < n; i++)
    {
        sat_count += (v[i] >= 2047);
        sat_count += (v[i] <= -2048);
        max = MAX(max, ABS(v[i]));
    }
#if 1
    if (sat_count > 0)
    {
        if (sat_count > 2)
        {
            if (sat_count > n / 64)
            {
                if (sat_count > n / 32)
                {
                    if (sat_count > n / 16)
                    {
                        if (sat_count > n / 8)
                        {
                            return -10;
                        }
                        return -5;
                    }
                    return -3;
                }
                return -2;
            }
            return -1;
        }
        return 0;
    }
#else
    if (sat_count > 0)
    {
        if (sat_count > n / 64)
        {
            if (sat_count > n / 32)
            {
                if (sat_count > n / 16)
                {
                    if (sat_count > n / 8)
                    {
                        return -10;
                    }
                    return -5;
                }
                return -3;
            }
            return -1;
        }
        return 0;
    }
#endif
    if (max < MIN_DESIRED_LEVEL)
    {
        int gain_db = 1 - (int)(10 * log10f((float)max / MIN_DESIRED_LEVEL));
        return gain_db;
    }
    return 0;
}

void set_custom_gain_table()
{
static const char* fixed_gain_tab = 
"<list>\n"
"<gaintable AD9361 type=FULL dest=3 start=4000000000 end=6000000000>\n"
//"<gaintable AD9361 type=FULL dest=3 start=1300000000 end=4000000000>\n"
"-10, 0x00, 0x00, 0x00\n"
"-10, 0x00, 0x00, 0x00\n"
"-10, 0x00, 0x00, 0x00\n"
"-10, 0x00, 0x00, 0x00\n"
"-10, 0x00, 0x00, 0x00\n"
"-9, 0x00, 0x01, 0x00\n"
"-8, 0x00, 0x02, 0x00\n"
"-7, 0x00, 0x03, 0x00\n"
"-6, 0x01, 0x01, 0x00\n"
"-5, 0x01, 0x02, 0x00\n"
"-4, 0x01, 0x03, 0x00\n"
"-3, 0x01, 0x04, 0x00\n"
"-2, 0x01, 0x05, 0x00\n"
"-1, 0x01, 0x06, 0x00\n"
"0, 0x01, 0x07, 0x00\n"
"1, 0x01, 0x08, 0x00\n"
"2, 0x01, 0x09, 0x00\n"
"3, 0x01, 0x0A, 0x00\n"
"4, 0x01, 0x0B, 0x00\n"
"5, 0x01, 0x0C, 0x00\n"
"6, 0x02, 0x08, 0x00\n"
"7, 0x02, 0x09, 0x00\n"
"8, 0x02, 0x0A, 0x00\n"
"9, 0x02, 0x0B, 0x00\n"
"10, 0x02, 0x0C, 0x00\n"
"11, 0x02, 0x0D, 0x00\n"
"12, 0x02, 0x0E, 0x00\n"
"13, 0x02, 0x0F, 0x00\n"
"14, 0x02, 0x2A, 0x00\n"
"15, 0x02, 0x2B, 0x00\n"
"16, 0x04, 0x27, 0x00\n"
"17, 0x04, 0x28, 0x00\n"
"18, 0x04, 0x29, 0x00\n"
"19, 0x04, 0x2A, 0x00\n"
"20, 0x04, 0x2B, 0x00\n"
"21, 0x04, 0x2C, 0x00\n"
"22, 0x04, 0x2D, 0x00\n"   //  mix = 4 gain = 15

//"23, 0x04, 0x2D, 0x00\n"
//"24, 0x04, 0x2D, 0x00\n"
"23, 0x24, 0x20, 0x00\n"  // mix = 4, gain  = 15
"24, 0x24, 0x21, 0x00\n"
"25, 0x24, 0x22, 0x00\n"
"26, 0x44, 0x20, 0x00\n"
"27, 0x44, 0x21, 0x00\n"
"28, 0x44, 0x22, 0x00\n"
"29, 0x44, 0x23, 0x00\n"
"30, 0x44, 0x24, 0x00\n"
"31, 0x44, 0x25, 0x00\n"
"32, 0x44, 0x26, 0x00\n"
"33, 0x44, 0x27, 0x00\n"
"34, 0x44, 0x28, 0x00\n"
"35, 0x44, 0x29, 0x00\n"
"36, 0x44, 0x2A, 0x00\n"
"37, 0x44, 0x2B, 0x00\n"
"38, 0x44, 0x2C, 0x00\n"
"39, 0x44, 0x2D, 0x00\n"
"40, 0x44, 0x2E, 0x00\n"
"41, 0x64, 0x2E, 0x00\n"
"42, 0x64, 0x2F, 0x00\n"
"43, 0x64, 0x30, 0x00\n"
"44, 0x64, 0x31, 0x00\n"
"45, 0x64, 0x32, 0x00\n"
"46, 0x64, 0x33, 0x00\n"
"47, 0x64, 0x34, 0x00\n"
"48, 0x64, 0x35, 0x00\n"
"49, 0x64, 0x36, 0x00\n"
"50, 0x64, 0x37, 0x00\n"
"51, 0x64, 0x38, 0x00\n"
"52, 0x65, 0x38, 0x00\n"
"53, 0x66, 0x38, 0x00\n"
"54, 0x67, 0x38, 0x00\n"
"55, 0x68, 0x38, 0x00\n"
"56, 0x69, 0x38, 0x00\n"
"57, 0x6A, 0x38, 0x00\n"
"58, 0x6B, 0x38, 0x00\n"
"59, 0x6C, 0x38, 0x00\n"
"60, 0x6D, 0x38, 0x00\n"
"61, 0x6E, 0x38, 0x00\n"
"62, 0x6F, 0x38, 0x00\n"
"</gaintable>\n"
"</list>\n"
;

    char gain_tab[2048];
    struct iio_device * dev = iio_context_get_device(g_iio_device, 0);
    fprintf(stderr, "device=(%s)\n", iio_device_get_name(dev));
    fflush(stderr);
    
    fprintf(stderr, "Gain table %d bytes write\n", (int)strlen(fixed_gain_tab));        fflush(stderr);

//    int err = iio_device_attr_read(dev, "gain_table_config", gain_tab, sizeof(gain_tab));
    int err = (int)iio_device_attr_write_raw(dev, "gain_table_config", fixed_gain_tab, strlen(fixed_gain_tab));
    
    if (err <= 0)
    {
        char str[256];
        iio_strerror(-err,str,sizeof(str));
        fprintf(stderr, "error %d writing gain table err=(%s)\n", err, str);
        fflush(stderr);
//        return;
    }

    err = (int)iio_device_attr_read(dev, "gain_table_config", gain_tab, sizeof(gain_tab));
    if (err <= 0)
    {
        char str[256];
        iio_strerror(-err,str,sizeof(str));
        fprintf(stderr, "error %d reading gain table err=(%s)\n", err, str);
        fflush(stderr);
        return;
    }
    fprintf(stderr, "%s\n", gain_tab);
    fprintf(stderr, "Gain table %d bytes read\n", err);        
    fflush(stderr);
}

static int init_agc_ch(int ch_num, e_agc_mode mode, int gain_db)
{
    if (g_rx.ch[ch_num].enabled)
    {
        gain_db = MIN(gain_db, g_rx_limit.ch[ch_num].gain_db.max);
        gain_db = MAX(gain_db, g_rx_limit.ch[ch_num].gain_db.min);
        struct iio_channel* chn = g_rx.ch[ch_num].iio_ch;
        switch (mode)
        {
        case AGC_SLOW:
            wr_ch_str(chn, "gain_control_mode", "slow_attack");
            break;
        case AGC_FAST:
            wr_ch_str(chn, "gain_control_mode", "fast_attack");
            break;
        case AGC_DISABLED:
            wr_ch_str(chn, "gain_control_mode", "manual");
            wr_ch_lli_unsafe(chn, "hardwaregain", gain_db);
            break;
        }
    }
    return gain_db;
}


static int start_channel(struct iio_device *rx, int ch_num, const ad936x_rx_channel_config* cfg)
{
    int success = 1;
    if (NULL == (g_rx.ch[ch_num].iio_ch = get_phy_chan(RX, ch_num)))
    {
        return 0;
    }
    success &= cfg_ad9361_streaming_ch(ch_num, cfg);
    success &= get_ad9361_stream_ch(RX, rx, ch_num*2+0, &g_rx.ch[ch_num].iio_stream_i);
    success &= get_ad9361_stream_ch(RX, rx, ch_num*2+1, &g_rx.ch[ch_num].iio_stream_q);
    iio_channel_enable(g_rx.ch[ch_num].iio_stream_i);
    iio_channel_enable(g_rx.ch[ch_num].iio_stream_q);
    g_rx.channels_mask |= (1 << ch_num);
    g_rx.ch[ch_num].enabled = success;
    g_rx.ch[ch_num].bw_mhz = cfg->bw_mhz;
    g_rx.ch[ch_num].fs_mhz = cfg->fs_mhz;
    init_agc_ch(ch_num, cfg->agc_mode, cfg->gain_db);
    return success;
}

int startup_rx(int center_mhz, const ad936x_rx_channel_config* ch1, const ad936x_rx_channel_config* ch2, int buf_size_us, int buf_size_samples)
{
    // Streaming devices
	struct iio_device *rx;

    sdr_get_limits();

    if (!init_iio_device_context() ||
        iio_context_get_devices_count(g_iio_device) <= 0
        )
    {
        printf("ERROR: IIO device not found!\n");
        return 0;
    }
    if ((ch1 && !g_rx_limit.ch[0].available) ||
        (ch2 && !g_rx_limit.ch[1].available)
        )
    {
        printf("ERROR: channel not available!\n");
        return 0;
    }

    //set_custom_gain_table();    // optional, useful for hardware debug

    rx = get_ad9361_stream_dev(RX);
    if (!rx)
    {
        printf("ERROR: RX streaming device not found!\n");
        return 0;
    }

    printf("* Configuring AD9361 for streaming\n");

    set_lo_freq_mhz_failsafe(center_mhz, 0);

    printf("* Initializing AD9361 IIO streaming channels\n");
    g_rx.channels_mask = 0;
    if (ch1 && !start_channel(rx, 0, ch1))
    {
        ABOCT("channel 0 not available!\n");
    }
    if (ch2 && !start_channel(rx, 1, ch2))
    {
        ABOCT("channel 1 not available!\n");
    }
    g_rx.num_channels_enabled = g_rx.ch[0].enabled + g_rx.ch[1].enabled;
    int max_fs_mhz = MAX(ch1?ch1->fs_mhz:0, ch2?ch2->fs_mhz:0);

    printf("* Creating non-cyclic IIO buffers with 1 MiS\n");
    //int buf_size = (int)(fs_max*1000000. / 1000 * BUF_SIZE_MS);
    //int buf_size = (int)(max_fs_mhz*1000000. / 1000 * BUF_SIZE_MS);
    int buf_size = (int)(max_fs_mhz*buf_size_us);
    
    buf_size = buf_size / 1024 * 1024;
    if (buf_size_samples)
        buf_size = buf_size_samples;

    printf("buf_size = %d us = %d samples @ %d mhz\n", buf_size_us, buf_size, max_fs_mhz);
    rxbuf = iio_device_create_buffer(rx, buf_size, false);
    if (!rxbuf) 
    {
        ABOCT("Could not create RX buffer (device already running?)\n");
    }

    if (!set_lo_freq_mhz(RX, center_mhz))
    {
        //ABOCT("set lo frequency %d\n", center_mhz);
        ABOCT("set lo frequency\n");
    }

    printf("* Starting IO streaming (press CTRL+C to cancel)\n");
    fflush(stdout);

//    iio_device_set_kernel_buffers_count(rx, 3);
    return buf_size;
}

// init AGC for 0, 1 or both channels (if nch == 2)
int init_agc(int ch_num, e_agc_mode mode, int gain_db)
{
    int gain = 0;
    if (ch_num == 0 || ch_num == 2)
    {
        gain = init_agc_ch(0, mode, gain_db);
    }
    if (ch_num == 1 || ch_num == 2)
    {
        gain = init_agc_ch(1, mode, gain_db);
    }
    return gain;
}

int agc_pipeline_stable(int iter, const short * iq, int niq, int *pgain_db)
{
    // manual AGC
    int gain_db = *pgain_db;
    int dgain = v_sat_count(iq, niq * 2);
    if (dgain != 0 &&   // gain change required
        (iter - g_rx.change_iter) > PIPELINE_LEN + 10   // enough time passed after last change
        )
    {
        gain_db += dgain;
        int nch = (g_rx.channels_mask == 2) ? 1 : 0;
        gain_db = MAX(gain_db, g_rx_limit.ch[nch].gain_db.min);
        gain_db = MIN(gain_db, g_rx_limit.ch[nch].gain_db.max);
        g_rx.change_iter = iter;
        int succcess = 1;
        if (g_rx.channels_mask & 1) 
            succcess &= set_gain_db(0, gain_db);
        if (g_rx.channels_mask & 2)
            succcess &= set_gain_db(1, gain_db);
        if (!succcess)
        {
            printf("ERROR bad gain %d\n", (int)gain_db);
        }
        *pgain_db = gain_db;
    }
    return iter > (int)(g_rx.change_iter + PIPELINE_LEN);
}

int agc_custom(const short * iq, int niq, int gain_db)
{
    // manual AGC
    int dgain = v_sat_count_lite(iq, niq * 2);
    gain_db += dgain;
    return gain_db;
}

void iio_set_blocking_mode(int is_blocking)
{
    iio_buffer_set_blocking_mode(rxbuf, is_blocking);
    g_rxbuf_blocking_mode = is_blocking;
}

short * read_iq(int * pniq)
{
    ssize_t nbytes_rx;
    do 
    {
        nbytes_rx = iio_buffer_refill(rxbuf);
    } while (nbytes_rx == -EAGAIN);
    if (nbytes_rx < 0)
    {
        return NULL;
    }
    if (!nbytes_rx)
    {
        return NULL;
    }

    short* p_dat = (short*)iio_buffer_start(rxbuf);
    short* p_end = (short*)iio_buffer_end(rxbuf);
    * pniq = (int)((p_end - p_dat) / (2*g_rx.num_channels_enabled)); 
    return p_dat;
}

static int set_phy_ch_param(int ch_num, const char* attr_name, int64_t val)
{
    if (!wr_ch_lli_unsafe(g_rx.ch[ch_num].iio_ch, attr_name, val))
    {
        printf("ERROR set %s %.0f\n", attr_name, (double)val);
        return 0;
    }
    return 1;
}

int set_lo_freq_mhz_failsafe(int center_mhz, int iter)
{
    if (set_lo_freq_mhz(RX, center_mhz))
    {
        g_rx.lo_mhz = center_mhz;
    }
    g_rx.change_iter = iter;
    return g_rx.lo_mhz;
}

int set_bw_freq_mhz_failsafe(int ch_num, int bw_mhz, int iter)
{
    if (set_phy_ch_param(ch_num, "rf_bandwidth", MHZ(bw_mhz)))
    {
        g_rx.ch[ch_num].bw_mhz = bw_mhz;
    }
    g_rx.change_iter = iter;
    return g_rx.ch[ch_num].bw_mhz;
}

int set_fs_freq_mhz_failsafe(int ch_num, int fs_mhz, int iter)
{
    if (set_phy_ch_param(ch_num, "sampling_frequency", MHZ(fs_mhz)))
    {
        g_rx.ch[ch_num].fs_mhz = fs_mhz;
    }
    g_rx.change_iter = iter;
    return g_rx.ch[ch_num].fs_mhz;
}

int get_ch_rx_gain_db(int ch_num)
{
    long long val;
    int err = iio_channel_attr_read_longlong(g_rx.ch[ch_num].iio_ch, "hardwaregain", &val);
    if (!err)
    {
        return (int)val;
    }
    return -1;
}

float get_ch_rssi_db(int ch_num)
{
    double val;
    int err = iio_channel_attr_read_double(g_rx.ch[ch_num].iio_ch, "rssi", &val);
    if (!err)
    {
        return (float)val;
    }
    return -1;
}


void rx_set_buf_size(size_t buf_size_samples)
{
    assert(rxbuf);
    iio_buffer_destroy(rxbuf);
    rxbuf = iio_device_create_buffer(get_ad9361_stream_dev(RX), buf_size_samples, false);
    if (!rxbuf)
    {
        ABOCT("Could not re-create RX buffer\n");
    }
    iio_set_blocking_mode(g_rxbuf_blocking_mode);
}

/************************************************************************/
/*                         TX                                           */
/************************************************************************/
typedef struct
{
    unsigned change_iter;
    int lo_mhz;
    int num_channels_enabled;
    int channels_mask;
    struct
    {
        int enabled;
        int bw_mhz;
        int fs_mhz;
        struct iio_channel* iio_ch;         // 'phy' channel "ad9361-phy"
        struct iio_channel* iio_stream_i;   // 'streaming' channel "cf-ad9361-lpc"
        struct iio_channel* iio_stream_q;
    } ch[2];
    int buf_size_samples;
} ad936x_tx_state_t;
ad936x_tx_state_t g_tx;
static struct iio_buffer* g_txbuf = NULL;



static bool cfg_ad9361_streaming_tx_ch(int ch_num, const ad936x_tx_channel_config* cfg)
{
    struct iio_channel* chn = g_tx.ch[ch_num].iio_ch;
    //wr_ch_str(chn, "rf_port_select", "A_BALANCED");
    wr_ch_str(chn, "rf_port_select", "A");
    wr_ch_lli(chn, "rf_bandwidth", MHZ(cfg->bw_mhz));
    wr_ch_lli(chn, "sampling_frequency", MHZ(cfg->fs_mhz));
    return true;
}

int set_gain_db_tx(int ch_num, int gain_db)
{
    struct iio_channel* chn = g_tx.ch[ch_num].iio_ch;
    if (!wr_ch_lli_unsafe(chn, "hardwaregain", gain_db))
    {
        printf("ERROR bad gain %d\n", (int)gain_db);
        return 0;
    }
    return 1;
}

static int start_channel_tx(struct iio_device* tx, int ch_num, const ad936x_tx_channel_config* cfg)
{
    int success = 1;
    if (NULL == (g_tx.ch[ch_num].iio_ch = get_phy_chan(TX, ch_num)))
    {
        return 0;
    }
    success &= cfg_ad9361_streaming_tx_ch(ch_num, cfg);
    success &= get_ad9361_stream_ch(TX, tx, ch_num * 2 + 0, &g_tx.ch[ch_num].iio_stream_i);
    success &= get_ad9361_stream_ch(TX, tx, ch_num * 2 + 1, &g_tx.ch[ch_num].iio_stream_q);
    iio_channel_enable(g_tx.ch[ch_num].iio_stream_i);
    iio_channel_enable(g_tx.ch[ch_num].iio_stream_q);
    g_tx.channels_mask |= (1 << ch_num);
    g_tx.ch[ch_num].enabled = success;
    g_tx.ch[ch_num].bw_mhz = cfg->bw_mhz;
    g_tx.ch[ch_num].fs_mhz = cfg->fs_mhz;
    return success;
}

int tx_set_lo_freq_mhz(int center_mhz)
{
    if (!set_lo_freq_mhz(TX, center_mhz))
    {
        printf("ERROR: Bad TX LO!\n");
        return 0;
    }
    return 1;
}
int tx_fs_freq_mhz(int ch_num, int mhz)
{
    struct iio_channel* chn = g_tx.ch[ch_num].iio_ch;
    int success = 1;
    success &= wr_ch_lli_unsafe(chn, "rf_bandwidth", MHZ(mhz));
    success &= wr_ch_lli_unsafe(chn, "sampling_frequency", MHZ(mhz));
    return success;
}

int startup_tx(int center_mhz, const ad936x_tx_channel_config* ch1, const ad936x_tx_channel_config* ch2, int buf_size_samples, int cyclic)
{
    // Streaming devices
    struct iio_device* tx;

    sdr_get_limits();

    if (!init_iio_device_context() ||
        iio_context_get_devices_count(g_iio_device) <= 0
        )
    {
        printf("ERROR: IIO device not found!\n");
        return 0;
    }
    if ((ch1 && !g_rx_limit.ch[0].available) ||
        (ch2 && !g_rx_limit.ch[1].available)
        )
    {
        printf("ERROR: channel not available!\n");
        return 0;
    }

    tx = get_ad9361_stream_dev(TX);
    if (!tx)
    {
        printf("ERROR: TX streaming device not found!\n");
        return 0;
    }

    printf("* Configuring AD9361 for streaming\n");

    if (!set_lo_freq_mhz(TX, center_mhz))
    {
        ABOCT("ERROR: Bad TX LO!\n");
    }

    printf("* Initializing AD9361 IIO streaming channels\n");
    g_tx.channels_mask = 0;
    if (ch1 && !start_channel_tx(tx, 0, ch1))
    {
        ABOCT("ERROR: channel 0 not available!\n");
    }
    if (ch2 && !start_channel_tx(tx, 1, ch2))
    {
        ABOCT("ERROR: channel 0 not available!\n");
    }
    g_tx.num_channels_enabled = g_tx.ch[0].enabled + g_tx.ch[1].enabled;
    int max_fs_mhz = MAX(ch1 ? ch1->fs_mhz : 0, ch2 ? ch2->fs_mhz : 0);

    printf("* Creating non-cyclic IIO buffers with 1 MiS\n");

    g_tx.buf_size_samples = buf_size_samples;
    g_txbuf = iio_device_create_buffer(tx, buf_size_samples, cyclic);
    if (!g_txbuf)
    {
        ABOCT("ERROR: channel 0 not available!\n");
    }
    iio_buffer_set_blocking_mode(g_txbuf, 0);

    printf("* Starting IO streaming (press CTRL+C to cancel)\n");
    fflush(stdout);

    set_gain_db_tx(0, 0);
    iio_device_set_kernel_buffers_count(tx, cyclic?0:4);

    return 1;
}


void tx_set_buf_size(size_t buf_size_samples, int cyclic)
{
    assert(g_txbuf);
    iio_buffer_destroy(g_txbuf);
    g_tx.buf_size_samples = buf_size_samples;
    g_txbuf = iio_device_create_buffer(get_ad9361_stream_dev(TX), buf_size_samples, cyclic);
    if (!g_txbuf)
    {
        ABOCT("ERROR: channel 0 not available!\n");
    }
    iio_buffer_set_blocking_mode(g_txbuf, 0);
}

void * get_tx_buf()
{
    //char * p1 = iio_buffer_start(g_txbuf, g_tx.ch[0].iio_ch);
    //char * p2 = iio_buffer_end(g_txbuf, g_tx.ch[0].iio_ch);
    //char * p3 = iio_buffer_first(g_txbuf, g_tx.ch[0].iio_ch);
    //int n = p2 - p1;
    //n = p3 - p1;
    return iio_buffer_first(g_txbuf, g_tx.ch[0].iio_ch);
}
void write_iq(short * iq)
{
//     if (iq)       
//         iio_buffer_set_data(g_txbuf, iq);
       //memcpy(iio_buffer_start(g_txbuf, g_tx.ch[0].iio_ch);
     if (iq)
         memcpy(iio_buffer_start(g_txbuf), iq, g_tx.buf_size_samples*2*sizeof(short));
     int res;
     do
     {
         res = iio_buffer_push(g_txbuf);
     } while (res == -EAGAIN || res == -EBUSY);

    //printf("push %d %d\n", g_tx.buf_size_samples, res/4);
}

void write_iq_no_block(short* iq)
{
    if (iq)
        memcpy(iio_buffer_start(g_txbuf), iq, g_tx.buf_size_samples * 2 * sizeof(short));
    int res = iio_buffer_push(g_txbuf);
 //   printf("push %d\n", res);
}
void write_iq_no_block2(short* iq)
{
    if (iq)
        memcpy(iio_buffer_start(g_txbuf), iq, g_tx.buf_size_samples * 2 * sizeof(short));
//    iio_buffer_push(g_txbuf);
}

void write_iq_part(short* iq, int n)
{
    if (iq)
        memcpy(iio_buffer_start(g_txbuf), iq, n * 2 * sizeof(short));
    int res = iio_buffer_push_partial(g_txbuf, n);
 //   assert(res == 4*n);
    if (res != 4*n)
    {
        // error
    }
    //printf("push %d\n", res);
}


#ifdef pluto_iio_TEST

#if defined _WIN32
#include <windows.h>
#else
#include <sys/time.h>
#include <stddef.h>
#endif

static int64_t now_usfn()
{
#if defined _WIN32
    FILETIME st;
    ULARGE_INTEGER t64;
    GetSystemTimeAsFileTime(&st);
    t64.LowPart = st.dwLowDateTime;
    t64.HighPart = st.dwHighDateTime;
    return (unsigned)((t64.QuadPart / 10) & (ULONGLONG)0xffffffff);
#else
    struct timeval te;
    gettimeofday(&te, NULL); // get current time
    long long us = te.tv_sec * 1000000LL + te.tv_usec;
    return us;
#endif
}

int main()
{
    int center_mhz = 2400;
    ad936x_rx_channel_config cfg;
    cfg.bw_mhz = 30;
    cfg.fs_mhz = 30;
    cfg.agc_mode = AGC_DISABLED;
    cfg.gain_db = 50;
#define BUF_SIZE_US 10
    int buf_size = startup_rx(1270, &cfg, NULL, BUF_SIZE_US, 100000);
    printf("SDR initialized with buffer %d samples (%d bytes)\n", buf_size, buf_size*4);

    unsigned i, sum_us = 0, max_us = 0, nloops = 100;

    for (i = 0; i < 100; i++)
    {
        unsigned t = now_usfn();
        int niq;
        void *p_dat = read_iq(&niq);
        t = now_usfn() - t;
        max_us = MAX(max_us, t);
        sum_us += t;
    }
    printf("read %d samples took %d ms, max sample rate = %.1f MHz\n", buf_size*nloops, sum_us/1000, (float)buf_size*nloops/sum_us);

    iio_shutdown();
    return 0;
}
#endif // pluto_iio_TEST