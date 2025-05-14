if (NOT scpm_gz_common_version)
    set(scpm_gz_common_version_major "6" CACHE STRING "")
    set(scpm_gz_common_version "${scpm_gz_common_version_major}.0.2" CACHE STRING "")
endif()
set(scpm_gz_common_repo "https://github.com/gazebosim/gz-common")

scpm_install(gz-utils)

if (NOT EXISTS ${scpm_work_dir}/gz_common-${scpm_gz_common_version_major}-${scpm_gz_common_version}.installed)
    scpm_download_github_archive("${scpm_gz_common_repo}" "gz-common${scpm_gz_common_version_major}_${scpm_gz_common_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-common-gz-common${scpm_gz_common_version_major}_${scpm_gz_common_version}")
    file(WRITE ${scpm_work_dir}/gz_common-${scpm_gz_common_version_major}-${scpm_gz_common_version}.installed)
endif()
set(scpm_gz_common_lib
    gz_common
    CACHE STRING ""
)
set(scpm_gz_common_lib_debug
    gz_commond
    CACHE STRING ""
)
set(scpm_gz_common_depends
    gz-utils
    CACHE STRING ""
)
