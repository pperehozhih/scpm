if (NOT scpm_glfw_version)
    set(scpm_glfw_version "1.6.35" CACHE STRING "")
endif()
set(scpm_png_repo "https://github.com/glfw/glfw.git")

if (NOT EXISTS ${scpm_work_dir}/png-${scpm_glfw_version}.installed)
    scpm_download_github_archive("${scpm_glfw_repo}" "v${scpm_glfw_version}")
    scpm_build_cmake("${scpm_work_dir}/glfw-${scpm_glfw_version}" "")
    file(WRITE ${scpm_work_dir}/png-${scpm_glfw_version}.installed)
endif()

set(scpm_glfw_lib
    glfw
    CACHE STRING ""
)
set(scpm_glfw_lib_debug
    glfwd
    CACHE STRING ""
)
set(scpm_glfw_depends
    ""
    CACHE STRING ""
)
