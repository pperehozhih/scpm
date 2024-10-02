if (NOT scpm_zip_version)
    set(scpm_zip_version "1.11.1" CACHE STRING "")
endif()
set(scpm_zip_repo "https://github.com/nih-at/libzip")

if (NOT EXISTS ${scpm_work_dir}/zip-${scpm_zip_version}.installed)
    scpm_download_github_archive("${scpm_zip_repo}" "v${scpm_zip_version}")
    scpm_build_cmake("${scpm_work_dir}/libzip-${scpm_zip_version}" "-DBUILD_SHARED_LIBS=OFF")
    file(WRITE ${scpm_work_dir}/zip-${scpm_zip_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_zip_lib
        libzip
        CACHE STRING ""
    )
    set(scpm_zip_lib_debug
        libzip
        CACHE STRING ""
    )
else()
    set(scpm_zip_lib
        libzip
        CACHE STRING ""
    )
endif()
set(scpm_zip_depends
    z
    CACHE STRING ""
)
