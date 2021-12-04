if (NOT scpm_nfd_version)
    set(scpm_nfd_version "master" CACHE STRING "")
endif()
set(scpm_nfd_repo "https://github.com/btzy/nativefiledialog-extended")

if (NOT EXISTS ${scpm_work_dir}/nfd-${scpm_nfd_version}.installed)
    if(EXISTS "${scpm_work_dir}/nfd-${scpm_nfd_version}")
    file(REMOVE_RECURSE "${scpm_work_dir}/nfd-${scpm_nfd_version}")
    endif()
    execute_process(
        COMMAND git clone -b ${scpm_nfd_version} --depth 1 ${scpm_nfd_repo} nfd-${scpm_nfd_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_nfd_clone_reult
    )
    if (NOT scpm_nfd_clone_reult EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_nfd_repo}")
    endif()
    scpm_build_cmake("${scpm_work_dir}/nfd-${scpm_nfd_version}" "")
    file(WRITE ${scpm_work_dir}/nfd-${scpm_nfd_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_nfd_lib
        nfd
        CACHE STRING ""
    )
    set(scpm_nfd_lib_debug
        nfdd
        CACHE STRING ""
    )
else()
    set(scpm_nfd_lib
        nfd
        CACHE STRING ""
    )
endif()
set(scpm_nfd_depends
    ""
    CACHE STRING ""
)
