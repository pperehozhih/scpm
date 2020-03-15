if (NOT scpm_jpeg_version)
    set(scpm_jpeg_version "2.0.2" CACHE STRING "")
endif()
set(scpm_jpeg_repo "https://github.com/libjpeg-turbo/libjpeg-turbo")

if (NOT EXISTS ${scpm_work_dir}/libjpeg-${scpm_jpeg_version}.installed)
    scpm_download_github_archive("${scpm_jpeg_repo}" "${scpm_jpeg_version}")
    scpm_build_cmake("${scpm_work_dir}/libjpeg-turbo-${scpm_jpeg_version}" "-DWITH_SIMD=OFF")
    file(WRITE ${scpm_work_dir}/libjpeg-${scpm_jpeg_version}.installed)
endif()

set(scpm_jpeg_lib
    jpeg
    CACHE STRING ""
)
set(scpm_jpeg_lib_debug
    jpegd
    CACHE STRING ""
)
set(scpm_jpeg_depends
    CACHE STRING ""
)
