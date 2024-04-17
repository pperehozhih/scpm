if (NOT scpm_abseil_version)
    set(scpm_abseil_version "20240116.2" CACHE STRING "")
endif()
set(scpm_abseil_repo "https://github.com/abseil/abseil-cpp")

if (NOT EXISTS ${scpm_work_dir}/abseil-${scpm_abseil_version}.installed)
    scpm_download_and_extract_archive("${scpm_abseil_repo}/archive/refs/tags" "${scpm_abseil_version}.tar.gz")
    scpm_build_cmake("${scpm_work_dir}/abseil-cpp-${scpm_abseil_version}")
    file(WRITE ${scpm_work_dir}/abseil-${scpm_abseil_version}.installed)
endif()

set(scpm_abseil_lib
    abseil
    CACHE STRING ""
)
set(scpm_abseil_lib_debug
    abseild
    CACHE STRING ""
)
set(scpm_abseil_depends
    CACHE STRING ""
)
