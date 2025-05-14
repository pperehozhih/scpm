if (NOT scpm_zeromq_version)
    set(scpm_zeromq_version "4.3.5" CACHE STRING "")
endif()
set(scpm_zeromq_repo "https://github.com/zeromq/libzmq")

if (NOT EXISTS ${scpm_work_dir}/zeromq-${scpm_zeromq_version}.installed)
    scpm_download_github_archive("${scpm_zeromq_repo}" "v${scpm_zeromq_version}")
    scpm_build_cmake("${scpm_work_dir}/libzmq-${scpm_zeromq_version}")
    file(WRITE ${scpm_work_dir}/zeromq-${scpm_zeromq_version}.installed)
endif()

set(scpm_zeromq_lib
    zeromq
    CACHE STRING ""
)

set(scpm_zeromq_lib_debug
    zeromqd
    CACHE STRING ""
)

set(scpm_zeromq_depends
    CACHE STRING ""
)
