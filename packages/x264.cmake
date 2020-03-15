if (NOT scpm_x264_version)
    set(scpm_x264_version "master" CACHE STRING "")
endif()
set(scpm_x264_repo "https://github.com/mirror/x264.git")

if (NOT EXISTS ${scpm_work_dir}/x264-${scpm_x264_version}.installed)
    scpm_clone_git("${scpm_x264_repo}" "${scpm_x264_version}")
    scpm_build_configure("${scpm_work_dir}/x264" --disable-asm --enable-static --disable-ffms --disable-lavf --disable-avs --disable-swscale)
    file(WRITE ${scpm_work_dir}/x264-${scpm_x264_version}.installed)
endif()

set(scpm_x264_lib
    x264
    CACHE STRING ""
)
set(scpm_x264_lib_debug
    x264
    CACHE STRING ""
)
set(scpm_x264_depends
    ""
    CACHE STRING ""
)
