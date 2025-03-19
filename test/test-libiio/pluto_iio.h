/** 02.03.2024 @file
*  
*/

#ifndef pluto_iio_H_INCLUDED
#define pluto_iio_H_INCLUDED

#ifdef __cplusplus
extern "C" {
#endif  //__cplusplus

typedef	enum
{
    AGC_SLOW,
    AGC_FAST,
    AGC_DISABLED
} e_agc_mode;
typedef struct 
{
    int bw_mhz;
    int fs_mhz;
    e_agc_mode agc_mode;
    int gain_db;
} ad936x_rx_channel_config;

/* RX is input, TX is output */
enum iodev { RX, TX };


typedef struct
{
    int min, max;
} int_range_t;

typedef struct
{
    int available;
    int_range_t gain_db;
    int_range_t bw_hz;
    int_range_t fs_hz;
} ad936x_channel_limits_t;

typedef struct
{
    ad936x_channel_limits_t ch[2];
    int_range_t lo_mhz;
    long long lo_hz[2];
} ad936x_rx_limits_t;

volatile ad936x_rx_limits_t * sdr_get_limits();

int startup_rx(int center_mhz, const ad936x_rx_channel_config * ch1, const ad936x_rx_channel_config * ch2, int buf_size_us, int buf_size_samples);


void iio_shutdown();
void iio_info();


short * read_iq(int * pniq);
void iio_set_blocking_mode(int is_blocking);
void rx_set_buf_size(size_t buf_size_samples);

int agc_pipeline_stable(int iter, const short * iq, int niq, int *pgain_db);
int init_agc(int ch_num, e_agc_mode mode, int gain_db);
void set_custom_gain_table();
int get_ch_rx_gain_db(int ch_num);


int set_lo_freq_mhz(enum iodev type, unsigned mhz);
int set_lo_freq_mhz_failsafe(int center_mhz, int iter);
int set_bw_freq_mhz_failsafe(int ch_num, int bw_mhz, int iter);
int set_fs_freq_mhz_failsafe(int ch_num, int bw_mhz, int iter);
int set_gain_db(int ch_num, int gain_db);
float get_ch_rssi_db(int ch_num);

int agc_custom(const short * iq, int niq, int gain_db);

int v_sat_count(const short *v, int n);
int v_sat_count_lite(const short *v, int n);
/************************************************************************/
/*                                                                      */
/************************************************************************/
typedef struct
{
    int bw_mhz;
    int fs_mhz;
} ad936x_tx_channel_config;


int startup_tx(int center_mhz, const ad936x_tx_channel_config* ch1, const ad936x_tx_channel_config* ch2, int buf_size_samples, int cyclic);
void write_iq(short* iq);
void write_iq_no_block(short* iq);
void write_iq_no_block2(short* iq);

void write_iq_part(short* iq, int n);
int tx_set_lo_freq_mhz(int center_mhz);
int tx_fs_freq_mhz(int ch_num, int mhz);

void tx_set_buf_size(size_t buf_size_samples, int cyclic);

void * get_tx_buf();






#ifdef __cplusplus
}
#endif //__cplusplus

#endif //pluto_iio_H_INCLUDED
