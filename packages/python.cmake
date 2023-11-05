if (NOT scpm_python_version)
    set(scpm_python_version "3.12.0" CACHE STRING "")
endif()
set(scpm_python_repo "https://github.com/python/cpython")

if (NOT EXISTS ${scpm_work_dir}/python-${scpm_python_version}.installed)
    scpm_download_github_archive("${scpm_python_repo}" "v${scpm_python_version}")
    scpm_build_configure("${scpm_work_dir}/cpython-${scpm_python_version}")
    scpm_build_make("${scpm_work_dir}/cpython-${scpm_python_version}")
    file(WRITE ${scpm_work_dir}/python-${scpm_python_version}.installed "")
endif()

set(scpm_python_lib
    ""
    CACHE STRING ""
)

set(scpm_python_lib_debug
    ""
    CACHE STRING ""
)

set(scpm_python_depends
    ""
    CACHE STRING ""
)
