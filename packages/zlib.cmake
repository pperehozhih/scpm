if (NOT scpm_zlib_version)
    set(scpm_zlib_version "1.2.11" CACHE STRING "")
endif()
set(scpm_zlib_repo "https://github.com/madler/zlib")

if (NOT EXISTS ${scpm_work_dir}/zlib-${scpm_zlib_version}.installed)
    scpm_download_github_archive("${scpm_zlib_repo}" "v${scpm_zlib_version}")
    scpm_build_cmake("${scpm_work_dir}/zlib-${scpm_zlib_version}")
    file(WRITE ${scpm_work_dir}/zlib-${scpm_zlib_version}.installed)
endif()

set(scpm_zlib_lib
    z
    CACHE STRING ""
)
set(scpm_zlib_lib_debug
    zd
    CACHE STRING ""
)
set(scpm_zlib_depends
    CACHE STRING ""
)
