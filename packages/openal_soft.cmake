if (NOT scpm_openal_soft_version)
    set(scpm_openal_soft_version "1.19.1" CACHE STRING "")
endif()
set(scpm_openal_soft_repo "https://github.com/kcat/openal-soft")

if (NOT EXISTS ${scpm_work_dir}/openal-soft-openal-soft-${scpm_openal_soft_version}.installed)
    scpm_download_github_archive("${scpm_openal_soft_repo}" "openal-soft-${scpm_openal_soft_version}")
    set(openal_soft_build_flag "-DALSOFT_UTILS=OFF" "-DALSOFT_EXAMPLES=OFF" "-DALSOFT_TESTS=OFF")
    scpm_build_cmake("${scpm_work_dir}/openal-soft-openal-soft-${scpm_openal_soft_version}" "${openal_soft_build_flag}")
    file(WRITE ${scpm_work_dir}/openal-soft-openal-soft-${scpm_openal_soft_version}.installed "")
endif()

set(scpm_openal_lib
    openal
    CACHE STRING ""
)
set(scpm_openal_lib_debug
    openald
    CACHE STRING ""
)
set(scpm_openal_depends
    ""
    CACHE STRING ""
)
