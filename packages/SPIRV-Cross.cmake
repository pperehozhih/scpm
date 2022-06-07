if (NOT scpm_spirv_cross_version)
    set(scpm_spirv_cross_version "2021-01-15" CACHE STRING "")
endif()
set(scpm_spirv_cross_repo "https://github.com/KhronosGroup/SPIRV-Cross")

if (NOT EXISTS ${scpm_work_dir}/spirv_cross-${scpm_spirv_cross_version}.installed)
    execute_process(
        COMMAND git clone -b ${scpm_spirv_cross_version} --depth 1 ${scpm_spirv_cross_repo} spirv_cross-${scpm_spirv_cross_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_spirv_cross_clone_reult
    )
    scpm_build_cmake("${scpm_work_dir}/spirv_cross-${scpm_spirv_cross_version}")
    file(WRITE ${scpm_work_dir}/spirv_cross-${scpm_spirv_cross_version}.installed "")
endif()

set(scpm_spirv_cross_lib
    CACHE STRING ""
)
set(scpm_spirv_cross_lib_debug
    CACHE STRING ""
)
set(scpm_spirv_cross_depends
    ""
    CACHE STRING ""
)
