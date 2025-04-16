if (NOT scpm_soapyplutosdr_version)
    set(scpm_soapyplutosdr_version "master" CACHE STRING "")
endif()
set(scpm_soapyplutosdr_repo "https://github.com/pothosware/SoapyPlutoSDR")

scpm_install(libiio)
scpm_install(soapysdr)

if (NOT EXISTS ${scpm_work_dir}/soapyplutosdr-${scpm_soapyplutosdr_version}.installed)
    if(EXISTS "${scpm_work_dir}/soapyplutosdr-${scpm_soapyplutosdr_version}")
        file(REMOVE_RECURSE "${scpm_work_dir}/soapyplutosdr-${scpm_soapyplutosdr_version}")
    endif()
    execute_process(
        COMMAND git clone -b ${scpm_soapyplutosdr_version} --depth 1 ${scpm_soapyplutosdr_repo} soapyplutosdr-${scpm_soapyplutosdr_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_soapyplutosdr_clone_reult
    )
    if (NOT scpm_soapyplutosdr_clone_reult EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_soapyplutosdr_repo}")
    endif()
    scpm_build_cmake("${scpm_work_dir}/soapyplutosdr-${scpm_soapyplutosdr_version}" "")
    file(WRITE ${scpm_work_dir}/soapyplutosdr-${scpm_soapyplutosdr_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_soapyplutosdr_lib
        soapyplutosdr
        CACHE STRING ""
    )
    set(scpm_soapyplutosdr_lib_debug
        soapyplutosdrd
        CACHE STRING ""
    )
elseif(scpm_platform_macos)
    set(scpm_soapyplutosdr_lib
        soapyplutosdr
        CACHE STRING ""
    )
else()
    set(scpm_soapyplutosdr_lib
        soapyplutosdr
        CACHE STRING ""
    )
endif()

set(scpm_soapyplutosdr_depends
    ""
    CACHE STRING ""
)
