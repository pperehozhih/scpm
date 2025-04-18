

if (NOT scpm_fftw3_version)
    set(scpm_fftw3_version "3.3.10" CACHE STRING "")
endif()
set(scpm_fftw3_repo "https://fftw.org/")

if (NOT EXISTS ${scpm_work_dir}/fftw3-${scpm_fftw3_version}.installed)
    # scpm_download_github_archive("${scpm_fftw3_repo}" "fftw-${scpm_fftw3_version}")
    scpm_download_and_extract_archive("${scpm_fftw3_repo}" "fftw-${scpm_fftw3_version}.tar.gz")
    scpm_build_cmake("${scpm_work_dir}/fftw-${scpm_fftw3_version}" "-DENABLE_TESTING=OFF" "-DENABLE_FLOAT=ON")
    file(WRITE ${scpm_work_dir}/fftw3-fftw-${scpm_fftw3_version}.installed)
endif()

set(scpm_fftw3_lib
    fftw3
    CACHE STRING ""
)
set(scpm_fftw3_lib_debug
    fftw3d
    CACHE STRING ""
)
set(scpm_fftw3_depends
    CACHE STRING ""
)
