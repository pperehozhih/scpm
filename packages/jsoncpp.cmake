if (NOT scpm_jsoncpp_version)
    set(scpm_jsoncpp_version "1.9.6" CACHE STRING "")
endif()
set(scpm_jsoncpp_repo "https://github.com/open-source-parsers/jsoncpp")

if (NOT EXISTS ${scpm_work_dir}/jsoncpp-${scpm_jsoncpp_version}.installed)
    scpm_download_github_archive("${scpm_jsoncpp_repo}" "${scpm_jsoncpp_version}")
    scpm_build_cmake("${scpm_work_dir}/jsoncpp-${scpm_jsoncpp_version}")
    file(WRITE ${scpm_work_dir}/jsoncpp-${scpm_jsoncpp_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_jsoncpp_lib
        jsoncpp
        CACHE STRING ""
    )
    set(scpm_jsoncpp_lib_debug
        jsoncppd
        CACHE STRING ""
    )
else()
    set(scpm_jsoncpp_lib
        jsoncpp
        CACHE STRING ""
    )
endif()
set(scpm_jsoncpp_depends
    CACHE STRING ""
)
