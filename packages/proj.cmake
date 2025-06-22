if (NOT scpm_proj_version)
    set(scpm_proj_version "9.6.0" CACHE STRING "")
endif()
set(scpm_proj_repo "https://github.com/OSGeo/PROJ")

if (NOT EXISTS ${scpm_work_dir}/proj-${scpm_proj_version}.installed)
    scpm_download_github_archive("${scpm_proj_repo}" "${scpm_proj_version}")
    scpm_build_cmake("${scpm_work_dir}/proj-${scpm_proj_version}")
    file(WRITE ${scpm_work_dir}/proj-${scpm_proj_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_proj_lib
        proj
        CACHE STRING ""
    )
    set(scpm_proj_lib_debug
        projd
        CACHE STRING ""
    )
else()
    set(scpm_proj_lib
        proj
        CACHE STRING ""
    )
endif()
set(scpm_proj_depends
    CACHE STRING ""
)
