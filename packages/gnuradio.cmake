if (NOT scpm_gnuradio_version)
    set(scpm_gnuradio_version "3.10.12.0" CACHE STRING "")
endif()
scpm_install(pybind11)
scpm_install(spdlog)
set(scpm_gnuradio_repo "https://github.com/gnuradio/gnuradio")

if (NOT EXISTS ${scpm_work_dir}/gnuradio-${scpm_gnuradio_version}.installed)
    scpm_download_github_archive("${scpm_gnuradio_repo}" "v${scpm_gnuradio_version}")
    scpm_build_cmake("${scpm_work_dir}/gnuradio-${scpm_gnuradio_version}" "-DPython_ROOT_DIR=\"${PYTHON_ROOT_DIR}\" -DPYBIND11_TEST=OFF")
    file(WRITE ${scpm_work_dir}/gnuradio-${scpm_gnuradio_version}.installed)
endif()

set(scpm_gnuradio_lib
    gnuradio
    CACHE STRING ""
)
set(scpm_gnuradio_lib_debug
    gnuradiod
    CACHE STRING ""
)
set(scpm_gnuradio_depends
    pybind11
    spdlog
    CACHE STRING ""
)
