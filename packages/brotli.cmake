if (NOT scpm_brotli_version)
    set(scpm_brotli_version "1.1.0" CACHE STRING "")
endif()
set(scpm_brotli_repo "https://github.com/google/brotli")

if (NOT EXISTS ${scpm_work_dir}/brotli-${scpm_brotli_version}.installed)
    scpm_download_github_archive("${scpm_brotli_repo}" "v${scpm_brotli_version}")
    scpm_build_cmake("${scpm_work_dir}/brotli-${scpm_brotli_version}" -DBUILD_SHARED_LIBS=OFF)
    file(WRITE ${scpm_work_dir}/brotli-${scpm_brotli_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_brotli_lib
        brotlicommon
        brotlidec
        brotlienc
        CACHE STRING ""
    )
    set(scpm_brotli_lib_debug
        brotlicommond
        brotlidecd
        brotliencd
        CACHE STRING ""
    )
else()
    set(scpm_brotli_lib
        brotlicommon
        brotlidec
        brotlienc
        CACHE STRING ""
    )
endif()
set(scpm_brotli_depends
    ""
    CACHE STRING ""
)
