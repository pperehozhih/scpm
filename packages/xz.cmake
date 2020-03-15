if (NOT scpm_xz_version)
    set(scpm_xz_version "5.2.2" CACHE STRING "")
endif()
set(scpm_xz_repo "https://github.com/xz-mirror/xz")

if (NOT EXISTS ${scpm_work_dir}/xz-${scpm_xz_version}.installed)
    scpm_download_and_extract_archive("${scpm_xz_repo}/releases/download/v${scpm_xz_version}/" "xz-${scpm_xz_version}.tar.gz")
    scpm_download_github_archive("${scpm_xz_repo}" "v${scpm_xz_version}")
    scpm_build_configure("${scpm_work_dir}/xz-${scpm_xz_version}")
    file(WRITE ${scpm_work_dir}/xz-${scpm_xz_version}.installed)
endif()

set(scpm_xz_lib
    lzma
    CACHE STRING ""
)
set(scpm_xz_lib_debug
    lzma
    CACHE STRING ""
)
set(scpm_xz_depends
    CACHE STRING ""
)
