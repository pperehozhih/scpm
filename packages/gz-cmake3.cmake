if (NOT scpm_gz_cmake3_version)
    set(scpm_gz_cmake3_version "3.5.5" CACHE STRING "")
endif()
set(scpm_gz_cmake3_repo "https://github.com/gazebosim/gz-cmake")

if (NOT EXISTS ${scpm_work_dir}/gz_cmake3-${scpm_gz_cmake3_version}.installed)
    scpm_download_github_archive("${scpm_gz_cmake3_repo}" "gz-cmake3_${scpm_gz_cmake3_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-cmake-gz-cmake3_${scpm_gz_cmake3_version}")
    file(WRITE ${scpm_work_dir}/gz_cmake3-${scpm_gz_cmake3_version}.installed)
endif()

set(scpm_gz_cmake3_lib
    ""
    CACHE STRING ""
)
set(scpm_gz_cmake3_lib_debug
    ""
    CACHE STRING ""
)
set(scpm_gz_cmake3_depends
    CACHE STRING ""
)
