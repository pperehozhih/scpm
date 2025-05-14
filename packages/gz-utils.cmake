if (NOT scpm_gz_utils_version)
    set(scpm_gz_utils_version_major "3" CACHE STRING "")
    set(scpm_gz_utils_version "${scpm_gz_utils_version_major}.1.1" CACHE STRING "")
endif()
set(scpm_gz_utils_repo "https://github.com/gazebosim/gz-utils")

scpm_install(eigen)
scpm_install(spdlog)

if (NOT EXISTS ${scpm_work_dir}/gz_utils-${scpm_gz_utils_version_major}-${scpm_gz_utils_version}.installed)
    scpm_download_github_archive("${scpm_gz_utils_repo}" "gz-utils${scpm_gz_utils_version_major}_${scpm_gz_utils_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-utils-gz-utils${scpm_gz_utils_version_major}_${scpm_gz_utils_version}")
    file(WRITE ${scpm_work_dir}/gz_utils-${scpm_gz_utils_version_major}-${scpm_gz_utils_version}.installed)
endif()
set(scpm_gz_utils_lib
    gz_utils
    CACHE STRING ""
)
set(scpm_gz_utils_lib_debug
    gz_utilsd
    CACHE STRING ""
)
set(scpm_gz_utils_depends
    CACHE STRING ""
)
