if (NOT scpm_python_version)
    set(scpm_python_version_major "3.12" CACHE STRING "")
    set(scpm_python_version "${scpm_python_version_major}.3" CACHE STRING "")
endif()
set(scpm_python_repo "https://github.com/python/cpython")

if (NOT EXISTS ${scpm_work_dir}/python-${scpm_python_version}.installed)
    scpm_download_github_archive("${scpm_python_repo}" "v${scpm_python_version}")
    scpm_build_configure("${scpm_work_dir}/cpython-${scpm_python_version}")
    scpm_build_make("${scpm_work_dir}/cpython-${scpm_python_version}")
    file(WRITE ${scpm_work_dir}/python-${scpm_python_version}.installed "")
endif()

set(BOOST_ENABLE_PYTHON ON CACHE STRING "")
set(PYTHON_ROOT_DIR "${scpm_root_dir}" CACHE STRING "")
include_directories("${scpm_root_dir}/include/python${scpm_python_version_major}")

set(scpm_python_lib
    "python${scpm_python_version_major}"
    CACHE STRING ""
)

set(scpm_python_lib_debug
    "python${scpm_python_version_major}d"
    CACHE STRING ""
)

set(scpm_python_depends
    ""
    CACHE STRING ""
)
