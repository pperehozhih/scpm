if (NOT scpm_quickjs_version)
    set(scpm_quickjs_version "2025-09-13" CACHE STRING "")
endif()
set(scpm_quickjs_repo "https://github.com/pperehozhih/quickjs")

if (NOT EXISTS ${scpm_work_dir}/quickjs-${scpm_quickjs_version}.installed)
    scpm_download_github_archive("${scpm_quickjs_repo}" "${scpm_quickjs_version}")
    scpm_build_cmake("${scpm_work_dir}/quickjs-${scpm_quickjs_version}" "-DQJS_BUILD_TOOLS=OFF")
    file(WRITE ${scpm_work_dir}/quickjs-${scpm_quickjs_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_quickjs_lib
        quickjs
        CACHE STRING ""
    )
    set(scpm_quickjs_lib_debug
        quickjsd
        CACHE STRING ""
    )
else()
    set(scpm_quickjs_lib
        quickjs
        CACHE STRING ""
    )
endif()
set(scpm_quickjs_depends
    CACHE STRING ""
)
