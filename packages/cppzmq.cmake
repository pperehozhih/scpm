if (NOT scpm_cppzmq_version)
    set(scpm_cppzmq_version "4.10.0" CACHE STRING "")
endif()
set(scpm_cppzmq_repo "https://github.com/zeromq/cppzmq")

scpm_install(zeromq)

if (NOT EXISTS ${scpm_work_dir}/cppzmq-${scpm_cppzmq_version}.installed)
    scpm_download_github_archive("${scpm_cppzmq_repo}" "v${scpm_cppzmq_version}")
    scpm_build_cmake("${scpm_work_dir}/cppzmq-${scpm_cppzmq_version}")
    file(WRITE ${scpm_work_dir}/cppzmq-${scpm_cppzmq_version}.installed)
endif()

set(scpm_cppzmq_lib
    CACHE STRING ""
)

set(scpm_cppzmq_lib_debug
    CACHE STRING ""
)

set(scpm_cppzmq_depends
    zeromq
    CACHE STRING ""
)
