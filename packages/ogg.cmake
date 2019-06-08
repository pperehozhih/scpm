if (NOT scpm_ogg_version)
    set(scpm_ogg_version "1.3.3" CACHE STRING "")
endif()
set(scpm_ogg_repo "https://github.com/xiph/ogg")

if (NOT EXISTS ${scpm_work_dir}/ogg-${scpm_ogg_version}.installed)
    scpm_download_github_archive("${scpm_ogg_repo}" "v${scpm_ogg_version}")
    scpm_build_cmake("${scpm_work_dir}/ogg-${scpm_ogg_version}")
    file(WRITE ${scpm_work_dir}/ogg-${scpm_ogg_version}.installed "")
endif()

set(scpm_ogg_lib
    ogg
    CACHE STRING ""
)
set(scpm_ogg_lib_debug
    oggd
    CACHE STRING ""
)
set(scpm_ogg_depends
    ""
    CACHE STRING ""
)
