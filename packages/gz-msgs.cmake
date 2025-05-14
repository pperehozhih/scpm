if (NOT scpm_gz_msgs_version)
    set(scpm_gz_msgs_version_major "11" CACHE STRING "")
    set(scpm_gz_msgs_version "${scpm_gz_msgs_version_major}.0.2" CACHE STRING "")
endif()
set(scpm_gz_msgs_repo "https://github.com/gazebosim/gz-msgs")

scpm_install(eigen)

if (NOT EXISTS ${scpm_work_dir}/gz_msgs-${scpm_gz_msgs_version_major}-${scpm_gz_msgs_version}.installed)
    scpm_download_github_archive("${scpm_gz_msgs_repo}" "gz-msgs${scpm_gz_msgs_version_major}_${scpm_gz_msgs_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-msgs-gz-msgs${scpm_gz_msgs_version_major}_${scpm_gz_msgs_version}")
    file(WRITE ${scpm_work_dir}/gz_msgs-${scpm_gz_msgs_version_major}-${scpm_gz_msgs_version}.installed)
endif()
set(scpm_gz_msgs_lib
    gz_msgs
    CACHE STRING ""
)
set(scpm_gz_msgs_lib_debug
    gz_msgsd
    CACHE STRING ""
)
set(scpm_gz_msgs_depends
    CACHE STRING ""
)
