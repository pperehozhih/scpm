if (NOT scpm_sdformat_version)
    set(scpm_sdformat_version_major "15"  CACHE STRING "")
    set(scpm_sdformat_version "${scpm_sdformat_version_major}.2.0" CACHE STRING "")
endif()
set(scpm_sdformat_repo "https://github.com/gazebosim/sdformat")

scpm_install(gz-math)
scpm_install(tinyxml2)

if (NOT EXISTS ${scpm_work_dir}/sdformat-${scpm_sdformat_version_major}-${scpm_sdformat_version}.installed)
    scpm_download_github_archive("${scpm_sdformat_repo}" "sdformat${scpm_sdformat_version_major}_${scpm_sdformat_version}")
    scpm_build_cmake("${scpm_work_dir}/sdformat-sdformat${scpm_sdformat_version_major}_${scpm_sdformat_version}")
    file(WRITE ${scpm_work_dir}/sdformat-${scpm_sdformat_version_major}-${scpm_sdformat_version}.installed)
endif()
set(scpm_sdformat_lib
    sdformat
    CACHE STRING ""
)
set(scpm_sdformat_lib_debug
    sdformatd
    CACHE STRING ""
)
set(scpm_sdformat_depends
    gz-math
    CACHE STRING ""
)
