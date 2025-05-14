if (NOT scpm_gz_math_version)
    set(scpm_gz_math_version_major "8" CACHE STRING "")
    set(scpm_gz_math_version "${scpm_gz_math_version_major}.1.1" CACHE STRING "")
endif()
set(scpm_gz_math_repo "https://github.com/gazebosim/gz-math")

scpm_install(eigen)
scpm_install(gz-utils)

if (NOT EXISTS ${scpm_work_dir}/gz_math-${scpm_gz_math_version_major}-${scpm_gz_math_version}.installed)
    scpm_download_github_archive("${scpm_gz_math_repo}" "gz-math${scpm_gz_math_version_major}_${scpm_gz_math_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-math-gz-math${scpm_gz_math_version_major}_${scpm_gz_math_version}")
    file(WRITE ${scpm_work_dir}/gz_math-${scpm_gz_math_version_major}-${scpm_gz_math_version}.installed)
endif()
set(scpm_gz_math_lib
    gz_math
    CACHE STRING ""
)
set(scpm_gz_math_lib_debug
    gz_mathd
    CACHE STRING ""
)
set(scpm_gz_math_depends
    gz-utils
    CACHE STRING ""
)
