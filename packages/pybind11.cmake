if (NOT scpm_pybind_version)
    set(scpm_pybind_version "2.12.0" CACHE STRING "")
endif()
set(scpm_pybind_repo "https://github.com/pybind/pybind11")

if (NOT EXISTS ${scpm_work_dir}/pybind-${scpm_pybind_version}.installed)
    scpm_download_github_archive("${scpm_pybind_repo}" "v${scpm_pybind_version}")
    scpm_build_cmake("${scpm_work_dir}/pybind11-${scpm_pybind_version}" "-DPython_ROOT_DIR=\"${PYTHON_ROOT_DIR}\" -DPYBIND11_TEST=OFF")
    file(WRITE ${scpm_work_dir}/pybind-${scpm_pybind_version}.installed)
endif()

set(scpm_pybind_lib
    pybind
    CACHE STRING ""
)
set(scpm_pybind_lib_debug
    pybindd
    CACHE STRING ""
)
set(scpm_pybind_depends
    CACHE STRING ""
)
