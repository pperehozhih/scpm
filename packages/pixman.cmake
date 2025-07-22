if (NOT scpm_pixman_version)
    set(scpm_pixman_version "0.46.4" CACHE STRING "")
endif()
set(scpm_pixman_repo "https://gitflic.ru/project/paul2la/pixman-cmake.git")

if (NOT EXISTS ${scpm_work_dir}/pixman-${scpm_pixman_version}.installed)
    scpm_clone_git("${scpm_pixman_repo}" "pixman-${scpm_pixman_version}-cmake-rc3")
    scpm_build_cmake("${scpm_work_dir}/pixman-cmake" "-DBUILD_TESTS=OFF")
    file(WRITE ${scpm_work_dir}/pixman-${scpm_pixman_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_pixman_lib
        pixman
        CACHE STRING ""
    )
    set(scpm_pixman_debug
        pixmand
        CACHE STRING ""
    )
else()
    set(scpm_pixman_lib
        pixman
        CACHE STRING ""
    )
endif()
set(scpm_pixman_depends
    CACHE STRING ""
)
