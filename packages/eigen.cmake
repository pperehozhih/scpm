if (NOT scpm_eigen_version)
    set(scpm_eigen_version "3.4.0" CACHE STRING "")
endif()
set(scpm_eigen_repo "https://gitflic.ru/project/paul2la/eigen.git")

if (NOT EXISTS ${scpm_work_dir}/eigen-${scpm_eigen_version}.installed)
    scpm_clone_git("${scpm_eigen_repo}" "${scpm_eigen_version}")
    scpm_build_cmake("${scpm_work_dir}/eigen" "-DBUILD_TESTING=OFF" "-DEIGEN_TEST_NOQT=OFF")
    file(WRITE ${scpm_work_dir}/eigen-${scpm_eigen_version}.installed)
endif()

set(scpm_eigen_lib
    eigen
    CACHE STRING ""
)

set(scpm_eigen_lib_debug
    eigend
    CACHE STRING ""
)
set(scpm_eigen_depends
    ""
    CACHE STRING ""
)
