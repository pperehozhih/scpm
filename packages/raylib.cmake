if (NOT scpm_raylib_version)
    set(scpm_raylib_version "5.5" CACHE STRING "")
endif()
set(scpm_raylib_repo "https://github.com/raysan5/raylib")

if (NOT EXISTS ${scpm_work_dir}/raylib-${scpm_raylib_version}.installed)
    scpm_download_github_archive("${scpm_raylib_repo}" "${scpm_raylib_version}")
    scpm_build_make("${scpm_work_dir}/raylib-${scpm_raylib_version}")
    file(WRITE ${scpm_work_dir}/raylib-${scpm_raylib_version}.installed "")
endif()

set(scpm_raylib_lib
    ""
    CACHE STRING ""
)

set(scpm_raylib_lib_debug
    ""
    CACHE STRING ""
)

set(scpm_raylib_depends
    ""
    CACHE STRING ""
)

