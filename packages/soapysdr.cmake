if (NOT scpm_soapysdr_version)
    set(scpm_soapysdr_version "master" CACHE STRING "")
endif()
set(scpm_soapysdr_repo "https://github.com/pothosware/SoapySDR")

if (NOT EXISTS ${scpm_work_dir}/soapysdr-${scpm_soapysdr_version}.installed)
    if(EXISTS "${scpm_work_dir}/soapysdr-${scpm_soapysdr_version}")
        file(REMOVE_RECURSE "${scpm_work_dir}/soapysdr-${scpm_soapysdr_version}")
    endif()
    execute_process(
        COMMAND git clone -b ${scpm_soapysdr_version} --depth 1 ${scpm_soapysdr_repo} soapysdr-${scpm_soapysdr_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_soapysdr_clone_reult
    )
    if (NOT scpm_soapysdr_clone_reult EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_soapysdr_repo}")
    endif()
    scpm_build_cmake("${scpm_work_dir}/soapysdr-${scpm_soapysdr_version}" "")
    file(WRITE ${scpm_work_dir}/soapysdr-${scpm_soapysdr_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_soapysdr_lib
        soapysdr
        CACHE STRING ""
    )
    set(scpm_soapysdr_lib_debug
        soapysdrd
        CACHE STRING ""
    )
elseif(scpm_platform_macos)
    set(scpm_soapysdr_lib
        soapysdr
        CACHE STRING ""
    )
else()
    set(scpm_soapysdr_lib
        soapysdr
        CACHE STRING ""
    )
endif()

set(scpm_soapysdr_depends
    ""
    CACHE STRING ""
)
