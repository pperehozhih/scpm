if (NOT scpm_liquid_version)
    set(scpm_liquid_version "1.7.0" CACHE STRING "")
endif()
set(scpm_liquid_repo "https://github.com/jgaeddert/liquid-dsp")

if (NOT EXISTS ${scpm_work_dir}/liquid-${scpm_liquid_version}.installed)
    scpm_download_github_archive("${scpm_liquid_repo}" "v${scpm_liquid_version}")
    scpm_build_cmake("${scpm_work_dir}/liquid-dsp-${scpm_liquid_version}" "-DBUILD_EXAMPLES=OFF" "-DBUILD_AUTOTESTS=OFF" "-DBUILD_BENCHMARKS=OFF")
    file(WRITE ${scpm_work_dir}/liquid-${scpm_liquid_version}.installed "")
endif()

set(scpm_liquid_lib
    liquid
    CACHE STRING ""
)
set(scpm_liquid_lib_debug
    liquidd
    CACHE STRING ""
)
set(scpm_liquid_depends
    ""
    CACHE STRING ""
)
