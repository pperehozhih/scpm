if (NOT scpm_bzip2_version)
    set(scpm_bzip2_version "master" CACHE STRING "")
endif()
set(scpm_bzip2_repo "https://github.com/WardF/libbzip2")

if (NOT EXISTS ${scpm_work_dir}/bzip2-${scpm_bzip2_version}.installed)
    scpm_clone_git("${scpm_bzip2_repo}" "${scpm_bzip2_version}")
    scpm_build_cmake("${scpm_work_dir}/libbzip2")
    file(WRITE ${scpm_work_dir}/bzip2-${scpm_bzip2_version}.installed)
endif()

set(scpm_bzip2_lib
    bzip2
    CACHE STRING ""
)
set(scpm_bzip2_lib_debug
    bzip2d
    CACHE STRING ""
)
set(scpm_bzip2_depends
    ""
    CACHE STRING ""
)
