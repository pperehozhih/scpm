if (NOT scpm_rapidjson_version)
    set(scpm_rapidjson_version "master" CACHE STRING "")
endif()
set(scpm_rapidjson_repo "https://github.com/Tencent/rapidjson")

if (NOT EXISTS ${scpm_work_dir}/rapidjson-${scpm_rapidjson_version}.installed)
    execute_process(
        COMMAND git clone -b ${scpm_rapidjson_version} --depth 1 ${scpm_rapidjson_repo} rapidjson-${scpm_rapidjson_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_clone_git_result
    )
    if (NOT scpm_clone_git_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_rapidjson_version}")
    endif()
    scpm_build_cmake("${scpm_work_dir}/rapidjson-${scpm_rapidjson_version}" "-DRAPIDJSON_BUILD_EXAMPLES=OFF" "-DRAPIDJSON_BUILD_TESTS=OFF")
    file(WRITE ${scpm_work_dir}/rapidjson-${scpm_rapidjson_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_rapidjson_lib
        rapidjson
        CACHE STRING ""
    )
    set(scpm_rapidjson_lib_debug
        rapidjsond
        CACHE STRING ""
    )
else()
    set(scpm_rapidjson_lib
        rapidjson
        CACHE STRING ""
    )
endif()
set(scpm_rapidjson_depends
    CACHE STRING ""
)
