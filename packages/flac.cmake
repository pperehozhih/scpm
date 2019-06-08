if (NOT scpm_flac_version)
    set(scpm_flac_version "master" CACHE STRING "")
endif()
set(scpm_flac_repo "https://github.com/xiph/flac")

if (NOT EXISTS ${scpm_work_dir}/flac-${scpm_flac_version}.installed)
    scpm_download_github_archive("${scpm_flac_repo}" "${scpm_flac_version}")
    # Hack for disable build utils
    file(WRITE "${scpm_work_dir}/flac-${scpm_flac_version}/src/utils/CMakeLists.txt" "")
    set(buildargs "-DBUILD_EXAMPLES=OFF" "-DBUILD_TESTING=OFF")
    scpm_build_cmake("${scpm_work_dir}/flac-${scpm_flac_version}" "${buildargs}")
    file(WRITE ${scpm_work_dir}/flac-${scpm_flac_version}.installed)
endif()

set(scpm_flac_lib
    flac
    CACHE STRING ""
)
set(scpm_flac_lib_debug
    flacd
    CACHE STRING ""
)
set(scpm_flac_depends
    ""
    CACHE STRING ""
)
