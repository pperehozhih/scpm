if (NOT scpm_soapyhackrf_version)
    set(scpm_soapyhackrf_version "master" CACHE STRING "")
endif()
set(scpm_soapyhackrf_repo "https://github.com/pothosware/SoapyHackRF")

scpm_install(hackrf)
scpm_install(soapysdr)

if (NOT EXISTS ${scpm_work_dir}/soapyhackrf-${scpm_soapyhackrf_version}.installed)
    if(EXISTS "${scpm_work_dir}/soapyhackrf-${scpm_soapyhackrf_version}")
        file(REMOVE_RECURSE "${scpm_work_dir}/soapyhackrf-${scpm_soapyhackrf_version}")
    endif()
    execute_process(
        COMMAND git clone -b ${scpm_soapyhackrf_version} --depth 1 ${scpm_soapyhackrf_repo} soapyhackrf-${scpm_soapyhackrf_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_soapyhackrf_clone_reult
    )
    if (NOT scpm_soapyhackrf_clone_reult EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_soapyhackrf_repo}")
    endif()
    scpm_build_cmake("${scpm_work_dir}/soapyhackrf-${scpm_soapyhackrf_version}" "")
    file(WRITE ${scpm_work_dir}/soapyhackrf-${scpm_soapyhackrf_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_soapyhackrf_lib
        soapyhackrf
        CACHE STRING ""
    )
    set(scpm_soapyhackrf_lib_debug
        soapyhackrfd
        CACHE STRING ""
    )
elseif(scpm_platform_macos)
    set(scpm_soapyhackrf_lib
        soapyhackrf
        CACHE STRING ""
    )
else()
    set(scpm_soapyhackrf_lib
        soapyhackrf
        CACHE STRING ""
    )
endif()

set(scpm_soapyhackrf_depends
    ""
    CACHE STRING ""
)
