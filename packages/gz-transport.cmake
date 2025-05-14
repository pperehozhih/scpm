if (NOT scpm_gz_transport_version)
    set(scpm_gz_transport_version_major "14" CACHE STRING "")
    set(scpm_gz_transport_version "${scpm_gz_transport_version_major}.0.1" CACHE STRING "")
endif()
set(scpm_gz_transport_repo "https://github.com/gazebosim/gz-transport")

scpm_install(sqlite3)
scpm_install(cppzmq)
scpm_install(gz-msgs)

if (NOT EXISTS ${scpm_work_dir}/gz_transport-${scpm_gz_transport_version_major}-${scpm_gz_transport_version}.installed)
    scpm_download_github_archive("${scpm_gz_transport_repo}" "gz-transport${scpm_gz_transport_version_major}_${scpm_gz_transport_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-transport-gz-transport${scpm_gz_transport_version_major}_${scpm_gz_transport_version}")
    file(WRITE ${scpm_work_dir}/gz_transport-${scpm_gz_transport_version_major}-${scpm_gz_transport_version}.installed)
endif()
set(scpm_gz_transport_lib
    gz_transport
    CACHE STRING ""
)
set(scpm_gz_transport_lib_debug
    gz_transportd
    CACHE STRING ""
)
set(scpm_gz_transport_depends
    sqlite3
    CACHE STRING ""
)
