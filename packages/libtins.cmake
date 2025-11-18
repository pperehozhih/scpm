if (NOT scpm_libtins_version)
    set(scpm_libtins_version "4.5" CACHE STRING "")
endif()
set(scpm_libtins_repo "https://github.com/mfontanini/libtins")

if (NOT EXISTS ${scpm_work_dir}/libtins-${scpm_libtins_version}.installed)
    scpm_download_github_archive("${scpm_libtins_repo}" "v${scpm_libtins_version}")
    scpm_build_cmake("${scpm_work_dir}/libtins-${scpm_libtins_version}")
    file(WRITE ${scpm_work_dir}/libtins-${scpm_libtins_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_libtins_lib
        libtins
        CACHE STRING ""
    )
    set(scpm_libtins_lib_debug
        libtinsd
        CACHE STRING ""
    )
else()
    set(scpm_libtins_lib
        tins
        CACHE STRING ""
    )
endif()
set(scpm_libtins_depends
    CACHE STRING ""
)
