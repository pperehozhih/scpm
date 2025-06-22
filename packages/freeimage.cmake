if (NOT scpm_freeimage_version)
    set(scpm_freeimage_version "3.19.10" CACHE STRING "")
endif()
set(scpm_freeimage_repo "https://github.com/danoli3/FreeImage")

if (NOT EXISTS ${scpm_work_dir}/freeimage-${scpm_freeimage_version}.installed)
    scpm_download_github_archive("${scpm_freeimage_repo}" "${scpm_freeimage_version}")
    scpm_build_cmake("${scpm_work_dir}/freeimage-${scpm_freeimage_version}")
    file(WRITE ${scpm_work_dir}/freeimage-${scpm_freeimage_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_freeimage_lib
        freeimage
        CACHE STRING ""
    )
    set(scpm_freeimage_lib_debug
        freeimaged
        CACHE STRING ""
    )
else()
    set(scpm_freeimage_lib
        freeimage
        CACHE STRING ""
    )
endif()
set(scpm_freeimage_depends
    CACHE STRING ""
)
