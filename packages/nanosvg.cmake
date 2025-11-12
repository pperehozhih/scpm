if (NOT scpm_nanosvg_version)
    set(scpm_nanosvg_version "master" CACHE STRING "")
endif()
set(scpm_nanosvg_repo "https://github.com/memononen/nanosvg")

if (NOT EXISTS ${scpm_work_dir}/nanosvg_${scpm_nanosvg_version}.installed)
    execute_process(
        COMMAND git clone -b ${scpm_nanosvg_version} --depth 1 ${scpm_nanosvg_repo} nanosvg_${scpm_nanosvg_version} 
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_clone_git_result
    )

    message("[SCPM] clone repos ${scpm_work_dir}/nanosvg_${scpm_nanosvg_version}/")
    scpm_build_cmake("${scpm_work_dir}/nanosvg_${scpm_nanosvg_version}")
    file(WRITE ${scpm_work_dir}/nanosvg_${scpm_nanosvg_version}.installed "")
endif()

set(scpm_nanosvg_lib
    nanosvg
    nanosvgrast
    CACHE STRING ""
)
set(scpm_nanosvg_debug
    nanosvgd
    nanosvgrastd
    CACHE STRING ""
)

set(scpm_nanosvg_depends
    ""
    CACHE STRING ""
)
