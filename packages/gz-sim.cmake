if (NOT scpm_gz_sim_version)
    set(scpm_gz_sim_version "9.1.0" CACHE STRING "")
endif()
set(scpm_gz_sim_repo "https://github.com/gazebosim/gz-sim")
scpm_install(sdformat)
scpm_install(gz-plugin)
scpm_install(gz-transport)
scpm_install(gz-common)

if (NOT EXISTS ${scpm_work_dir}/gz_sim-${scpm_gz_sim_version}.installed)
    scpm_download_github_archive("${scpm_gz_sim_repo}" "gz-sim9_${scpm_gz_sim_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-sim-gz-sim9_${scpm_gz_sim_version}")
    file(WRITE ${scpm_work_dir}/gz_sim-${scpm_gz_sim_version}.installed)
endif()

set(scpm_gz_sim_lib
    ""
    CACHE STRING ""
)
set(scpm_gz_sim_lib_debug
    ""
    CACHE STRING ""
)
set(scpm_gz_sim_depends
    sdformat
    gz-plugin
    gz-transport
    CACHE STRING ""
)
