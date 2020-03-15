if (NOT scpm_yuv_version)
    set(scpm_yuv_version "cmake_improvements" CACHE STRING "")
endif()
scpm_install(jpeg)
set(scpm_yuv_repo "https://github.com/lemenkov/libyuv")

if (NOT EXISTS ${scpm_work_dir}/libyuv-${scpm_yuv_version}.installed)
    scpm_clone_git("${scpm_yuv_repo}" ${scpm_yuv_version})
    scpm_build_cmake("${scpm_work_dir}/libyuv")
    file(WRITE ${scpm_work_dir}/libyuv-${scpm_yuv_version}.installed)
endif()

set(scpm_yuv_lib
    yuv
    CACHE STRING ""
)
set(scpm_yuv_lib_debug
    yuvd
    CACHE STRING ""
)
set(scpm_yuv_depends
    jpeg
    CACHE STRING ""
)
