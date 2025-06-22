if (NOT scpm_assimp_version)
    set(scpm_assimp_version "5.4.3" CACHE STRING "")
endif()
set(scpm_assimp_repo "https://github.com/assimp/assimp")

if (NOT EXISTS ${scpm_work_dir}/assimp-${scpm_assimp_version}.installed)
    scpm_download_github_archive("${scpm_assimp_repo}" "v${scpm_assimp_version}")
    scpm_build_cmake("${scpm_work_dir}/assimp-${scpm_assimp_version}")
    file(WRITE ${scpm_work_dir}/assimp-${scpm_assimp_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_assimp_lib
        assimp
        CACHE STRING ""
    )
    set(scpm_assimp_lib_debug
        assimpd
        CACHE STRING ""
    )
else()
    set(scpm_assimp_lib
        assimp
        CACHE STRING ""
    )
endif()
set(scpm_assimp_depends
    CACHE STRING ""
)
