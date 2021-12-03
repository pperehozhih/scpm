if (NOT scpm_brotli_version)
    set(scpm_brotli_version "1.0.9" CACHE STRING "")
endif()
set(scpm_brotli_repo "https://github.com/google/brotli")

if (NOT EXISTS ${scpm_work_dir}/brotli-${scpm_brotli_version}.installed)
    scpm_download_github_archive("${scpm_brotli_repo}" "v${scpm_brotli_version}")
    scpm_build_cmake("${scpm_work_dir}/brotli-${scpm_brotli_version}")
    file(WRITE ${scpm_work_dir}/brotli-${scpm_brotli_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_brotli_lib
        brotli
        CACHE STRING ""
    )
    set(scpm_brotli_lib_debug
        brotlid
        CACHE STRING ""
    )
else()
    set(scpm_brotli_lib
        CACHE STRING ""
    )
endif()
set(scpm_brotli_depends
    CACHE STRING ""
)
