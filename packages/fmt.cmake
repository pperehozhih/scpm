if (NOT scpm_fmt_version)
    set(scpm_fmt_version "10.2.1" CACHE STRING "")
endif()
set(scpm_fmt_repo "https://github.com/fmtlib/fmt")

if (NOT EXISTS ${scpm_work_dir}/fmt-${scpm_fmt_version}.installed)
    scpm_download_github_archive("${scpm_fmt_repo}" "${scpm_fmt_version}")
    scpm_build_cmake("${scpm_work_dir}/fmt-${scpm_fmt_version}")
    file(WRITE ${scpm_work_dir}/fmt-${scpm_fmt_version}.installed)
endif()

set(scpm_fmt_lib
    fmt
    CACHE STRING ""
)
set(scpm_fmt_lib_debug
    fmtd
    CACHE STRING ""
)
set(scpm_fmt_depends
    CACHE STRING ""
)
