if (NOT openal_soft_version)
    set(openal_soft_version "1.19.1" CACHE STRING "")
endif()
set(openal_soft_repo "https://github.com/kcat/openal-soft")

if (NOT EXISTS ${scpm_work_dir}/openal-soft-openal-soft-${openal_soft_version}.installed)
    scpm_download_github_archive("${openal_soft_repo}" "openal-soft-${openal_soft_version}")
    set(openal_soft_build_flag "-DALSOFT_UTILS=OFF" "-DALSOFT_EXAMPLES=OFF" "-DALSOFT_TESTS=OFF")
    scpm_build_cmake("${scpm_work_dir}/openal-soft-openal-soft-${openal_soft_version}" "${openal_soft_build_flag}")
    file(WRITE ${scpm_work_dir}/openal-soft-openal-soft-${openal_soft_version}.installed "")
endif()

set(openal_lib
    openal
    CACHE STRING ""
)
set(openal_lib_debug
    openald
    CACHE STRING ""
)
