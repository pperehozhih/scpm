if (NOT scpm_bullet3_version)
    set(scpm_bullet3_version "3.17" CACHE STRING "")
endif()
set(scpm_bullet3_repo "https://github.com/bullet3/bullet3")

if (NOT EXISTS ${scpm_work_dir}/bullet3-${scpm_bullet3_version}.installed)
    scpm_download_github_archive("${scpm_bullet3_repo}" "${scpm_bullet3_version}")
    scpm_build_cmake("${scpm_work_dir}/bullet3-${scpm_bullet3_version}")
    file(WRITE ${scpm_work_dir}/bullet3-${scpm_bullet3_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_bullet3_lib
        bullet3
        CACHE STRING ""
    )
    set(scpm_bullet3_lib_debug
        bullet3d
        CACHE STRING ""
    )
else()
    set(scpm_bullet3_lib
        bullet3
        CACHE STRING ""
    )
endif()
set(scpm_bullet3_depends
    CACHE STRING ""
)
