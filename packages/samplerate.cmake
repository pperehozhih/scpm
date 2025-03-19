if (NOT scpm_samplerate_version)
    set(scpm_samplerate_version "0.2.2" CACHE STRING "")
endif()
set(scpm_samplerate_repo "https://github.com/libsndfile/libsamplerate")

if (NOT EXISTS ${scpm_work_dir}/samplerate-${scpm_samplerate_version}.installed)
    scpm_download_github_archive("${scpm_samplerate_repo}" "${scpm_samplerate_version}")
    scpm_build_cmake("${scpm_work_dir}/libsamplerate-${scpm_samplerate_version}")
    file(WRITE ${scpm_work_dir}/samplerate-${scpm_samplerate_version}.installed)
endif()

set(scpm_samplerate_lib
    samplerate
    CACHE STRING ""
)
set(scpm_samplerate_lib_debug
    samplerated
    CACHE STRING ""
)
set(scpm_samplerate_depends
    CACHE STRING ""
)
