if (NOT scpm_ffmpeg_version)
    set(scpm_ffmpeg_version "4.1.3" CACHE STRING "")
endif()
set(scpm_ffmpeg_repo "https://github.com/FFmpeg/FFmpeg")
scpm_install(x264)
scpm_install(fdkaac)
scpm_install(bzip2)
scpm_install(zlib)
scpm_install(xz)
if (NOT EXISTS ${scpm_work_dir}/ffmpeg-${scpm_ffmpeg_version}.installed)
    scpm_download_github_archive("${scpm_ffmpeg_repo}" "n${scpm_ffmpeg_version}")
    scpm_build_configure("${scpm_work_dir}/FFmpeg-n${scpm_ffmpeg_version}"
        --disable-asm
        --disable-sdl2
        --disable-libxcb
        --enable-libx264
        --enable-gpl
        --enable-libfdk-aac
        --enable-nonfree
        --extra-ldflags="-L${scpm_root_dir}/lib"
        --extra-cflags="-I${scpm_root_dir}/include"
    )
    file(WRITE ${scpm_work_dir}/ffmpeg-${scpm_ffmpeg_version}.installed)
endif()

set(scpm_ffmpeg_lib
    avcodec
    avdevice
    avfilter
    avformat
    avutil
    swresample
    swscale
    postproc
    "-framework AVFoundation"
    "-framework Security"
    "-framework AudioToolbox"
    "-framework CoreMedia"
    "-framework CoreVideo"
    "-framework VideoToolbox"
    "-framework CoreImage"
    CACHE STRING ""
)
set(scpm_ffmpeg_lib_debug
    avcodec
    avdevice
    avfilter
    avformat
    avutil
    swresample
    swscale
    postproc
    "-framework AVFoundation"
    "-framework Security"
    "-framework AudioToolbox"
    "-framework CoreMedia"
    "-framework CoreVideo"
    "-framework VideoToolbox"
    "-framework CoreImage"
    CACHE STRING ""
)
set(scpm_ffmpeg_depends
    fdkaac
    x264
    bzip2
    zlib
    xz
    CACHE STRING ""
)
