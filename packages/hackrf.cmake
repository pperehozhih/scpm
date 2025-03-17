
if (NOT scpm_hackrf_version)
    set(scpm_hackrf_version "2024.02.1" CACHE STRING "")
endif()
set(scpm_hackrf_repo "https://github.com/greatscottgadgets/hackrf")

if (NOT EXISTS ${scpm_work_dir}/hackrf-${scpm_hackrf_version}.installed)
    scpm_download_github_archive("${scpm_hackrf_repo}" "v${scpm_hackrf_version}")
    scpm_build_cmake("${scpm_work_dir}/hackrf-${scpm_hackrf_version}/host/")
    file(WRITE ${scpm_work_dir}/hackrf-${scpm_hackrf_version}.installed)
endif()

set(scpm_hackrf_lib
    hackrf
    CACHE STRING ""
)
set(scpm_hackrf_lib_debug
    hackrfd
    CACHE STRING ""
)
set(scpm_hackrf_depends
    CACHE STRING ""
)
