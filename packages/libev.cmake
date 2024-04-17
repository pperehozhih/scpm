if (NOT scpm_libev_version)
    set(scpm_libev_version "4.33" CACHE STRING "")
endif()
set(scpm_libev_repo "http://dist.schmorp.de/libev/Attic/")

if (NOT EXISTS ${scpm_work_dir}/libev-${scpm_libev_version}.installed)
    scpm_download_and_extract_archive("${scpm_libev_repo}" "libev-${scpm_libev_version}.tar.gz")
    scpm_build_configure("${scpm_work_dir}/libev-${scpm_libev_version}")
    file(WRITE ${scpm_work_dir}/libev-${scpm_libev_version}.installed)
endif()

set(scpm_libev_lib
    ev
    CACHE STRING ""
)
set(scpm_libev_lib_debug
    evd
    CACHE STRING ""
)
set(scpm_libev_depends
    ""
    CACHE STRING ""
)
