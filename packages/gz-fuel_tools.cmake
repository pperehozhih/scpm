if (NOT scpm_gz_fuel_tools_version)
    set(scpm_gz_fuel_tools_version_major "10" CACHE STRING "")
    set(scpm_gz_fuel_tools_version "${scpm_gz_fuel_tools_version_major}.0.1" CACHE STRING "")
endif()
set(scpm_gz_fuel_tools_repo "https://github.com/gazebosim/gz-fuel-tools")

scpm_install(jsoncpp)
scpm_install(zip)

if (NOT EXISTS ${scpm_work_dir}/gz_fuel_tools-${scpm_gz_fuel_tools_version_major}-${scpm_gz_fuel_tools_version}.installed)
    scpm_download_github_archive("${scpm_gz_fuel_tools_repo}" "gz-fuel-tools${scpm_gz_fuel_tools_version_major}_${scpm_gz_fuel_tools_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-fuel-tools-gz-fuel-tools${scpm_gz_fuel_tools_version_major}_${scpm_gz_fuel_tools_version}")
    file(WRITE ${scpm_work_dir}/gz_fuel_tools-${scpm_gz_fuel_tools_version_major}-${scpm_gz_fuel_tools_version}.installed)
endif()
set(scpm_gz_fuel_tools_lib
    gz_fuel_tools
    CACHE STRING ""
)
set(scpm_gz_fuel_tools_lib_debug
    gz_fuel_toolsd
    CACHE STRING ""
)
set(scpm_gz_fuel_tools_depends
    CACHE STRING ""
)
