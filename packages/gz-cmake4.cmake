if (NOT scpm_gz_cmake_version)
    set(scpm_gz_cmake_version "4.2.0" CACHE STRING "")
endif()
set(scpm_gz_cmake_repo "https://github.com/gazebosim/gz-cmake")

if (NOT EXISTS ${scpm_work_dir}/gz_cmake-${scpm_gz_cmake_version}.installed)
    scpm_download_github_archive("${scpm_gz_cmake_repo}" "gz-cmake4_${scpm_gz_cmake_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-cmake-gz-cmake4_${scpm_gz_cmake_version}")
    file(WRITE ${scpm_work_dir}/gz_cmake-${scpm_gz_cmake_version}.installed)
endif()

set(scpm_gz_cmake_lib
    ""
    CACHE STRING ""
)
set(scpm_gz_cmake_lib_debug
    ""
    CACHE STRING ""
)
set(scpm_gz_cmake_depends
    CACHE STRING ""
)
