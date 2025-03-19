

if (NOT scpm_fftw3_version)
    set(scpm_fftw3_version "3.3.10" CACHE STRING "")
endif()

set(scpm_fftw3_repo "https://github.com/FFTW/fftw3")

if (NOT EXISTS ${scpm_work_dir}/fftw3-${scpm_fftw3_version}.installed)
    scpm_download_github_archive("${scpm_fftw3_repo}" "fftw-${scpm_fftw3_version}")
    scpm_build_cmake("${scpm_work_dir}/fftw3-fftw-${scpm_fftw3_version}" "-DENABLE_TESTING=OFF")
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
