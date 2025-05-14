if (NOT scpm_tinyxml2_version)
    set(scpm_tinyxml2_version "11.0.0" CACHE STRING "")
endif()
set(scpm_tinyxml2_repo "https://github.com/leethomason/tinyxml2")

if (NOT EXISTS ${scpm_work_dir}/tinyxml2-${scpm_tinyxml2_version}.installed)
    scpm_download_github_archive("${scpm_tinyxml2_repo}" "${scpm_tinyxml2_version}")
    scpm_build_cmake("${scpm_work_dir}/tinyxml2-${scpm_tinyxml2_version}")
    file(WRITE ${scpm_work_dir}/tinyxml2-${scpm_tinyxml2_version}.installed)
endif()

set(scpm_tinyxml2_lib
    tinyxml2
    CACHE STRING ""
)

set(scpm_tinyxml2_lib_debug
    tinyxml2d
    CACHE STRING ""
)

set(scpm_tinyxml2_depends
    CACHE STRING ""
)
