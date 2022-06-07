if (NOT scpm_glslang_version)
    set(scpm_glslang_version "11.10.0" CACHE STRING "")
endif()
set(scpm_glslang_repo "https://github.com/KhronosGroup/glslang")

if (NOT EXISTS ${scpm_work_dir}/glslang-${scpm_glslang_version}.installed)
    execute_process(
        COMMAND git clone -b ${scpm_glslang_version} --depth 1 ${scpm_glslang_repo} glslang-${scpm_glslang_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_glslang_clone_reult
    )
    scpm_build_cmake("${scpm_work_dir}/glslang-${scpm_glslang_version}")
    file(WRITE ${scpm_work_dir}/glslang-${scpm_glslang_version}.installed "")
endif()

set(scpm_glslang_lib
    CACHE STRING ""
)
set(scpm_glslang_lib_debug
    CACHE STRING ""
)
set(scpm_glslang_depends
    ""
    CACHE STRING ""
)
