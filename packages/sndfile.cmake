

if (NOT scpm_sndfile_version)
    set(scpm_sndfile_version "1.2.2" CACHE STRING "")
endif()

set(scpm_sndfile_repo "https://github.com/libsndfile/libsndfile")

if (NOT EXISTS ${scpm_work_dir}/sndfile-${scpm_sndfile_version}.installed)
    scpm_download_github_archive("${scpm_sndfile_repo}" "${scpm_sndfile_version}")
    scpm_build_cmake("${scpm_work_dir}/libsndfile-${scpm_sndfile_version}" "-DENABLE_TESTING=OFF")
    file(WRITE ${scpm_work_dir}/sndfile-${scpm_sndfile_version}.installed)
endif()

set(scpm_sndfile_lib
    sndfile
    CACHE STRING ""
)
set(scpm_fsndfile_lib_debug
    sndfiled
    CACHE STRING ""
)
set(scpm_sndfile_depends
    CACHE STRING ""
)
