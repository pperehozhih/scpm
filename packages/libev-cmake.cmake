if (NOT scpm_libev_cmake_version)
	set(scpm_libev_cmake_version "4.33.0" CACHE STRING "")
endif()
set(scpm_libev_cmake_repo "https://github.com/pperehozhih/libev-cmake")

if (NOT EXISTS ${scpm_work_dir}/libev-cmake-${scpm_libev_cmake_version}.installed)
    scpm_clone_git("${scpm_libev_cmake_repo}" "master")
    scpm_clone_git_submodule_update("${scpm_work_dir}/libev-cmake")
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E rename "${scpm_work_dir}/libev-cmake" "${scpm_work_dir}/libev-cmake_${scpm_libev_cmake_version}"
    )
	scpm_build_cmake("${scpm_work_dir}/libev-cmake_${scpm_libev_cmake_version}" "-DCMAKE_CXX_FLAGS='-I${scpm_root_dir}/include'")
	file(WRITE ${scpm_work_dir}/libev-cmake-${scpm_libev_cmake_version}.installed "")
endif()

set(scpm_libev_lib
	ev
	CACHE STRING ""
)

set(scpm_libev_lib_debug
	evd
	CACHE STRING ""
)

set(scpm_libev_depends
	""
	CACHE STRING ""
)

