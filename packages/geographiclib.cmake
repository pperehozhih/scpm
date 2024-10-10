if (NOT scpm_geographiclib_version)
    set(scpm_geographiclib_version "v2.4" CACHE STRING "")
endif()
set(scpm_geographiclib_repo "https://github.com/geographiclib/geographiclib")

if (NOT EXISTS ${scpm_work_dir}/geographiclib-${scpm_geographiclib_version}.installed)
    if(EXISTS "${scpm_work_dir}/geographiclib-${scpm_geographiclib_version}")
        file(REMOVE_RECURSE "${scpm_work_dir}/geographiclib-${scpm_geographiclib_version}")
    endif()
    execute_process(
        COMMAND git clone -b ${scpm_geographiclib_version} --depth 1 ${scpm_geographiclib_repo} geographiclib-${scpm_geographiclib_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_geographiclib_clone_reult
    )
    if (NOT scpm_geographiclib_clone_reult EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_geographiclib_repo}")
    endif()
    scpm_build_cmake("${scpm_work_dir}/geographiclib-${scpm_geographiclib_version}" "-DBUILD_SHARED_LIBS=OFF" "-DCMAKE_CXX_FLAGS=\"-Wno-shorten-64-to-32\"")
    file(WRITE ${scpm_work_dir}/geographiclib-${scpm_geographiclib_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_geographiclib_lib
        geographiclib
        CACHE STRING ""
    )
    set(scpm_geographiclib_lib_debug
        geographiclibd
        CACHE STRING ""
    )
elseif(scpm_platform_macos)
    set(scpm_geographiclib_lib
        geographiclib
        CACHE STRING ""
    )
else()
    set(scpm_geographiclib_lib
        geographiclib
        CACHE STRING ""
    )
endif()

set(scpm_geographiclib_depends
    ""
    CACHE STRING ""
)
