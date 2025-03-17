if (NOT scpm_spdlog_version)
    set(scpm_spdlog_version "1.15.1" CACHE STRING "")
endif()
scpm_install(fmt)
set(scpm_spdlog_repo "https://github.com/gabime/spdlog")

if (NOT EXISTS ${scpm_work_dir}/spdlog-${scpm_spdlog_version}.installed)
    scpm_download_github_archive("${scpm_spdlog_repo}" "v${scpm_spdlog_version}")
    scpm_build_cmake("${scpm_work_dir}/spdlog-${scpm_spdlog_version}")
    file(WRITE ${scpm_work_dir}/spdlog-${scpm_spdlog_version}.installed)
endif()

set(scpm_spdlog_lib
    spdlog
    CACHE STRING ""
)
set(scpm_spdlog_lib_debug
    spdlogd
    CACHE STRING ""
)
set(scpm_spdlog_depends
    fmt
    CACHE STRING ""
)
