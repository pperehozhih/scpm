if (scpm_imgui_lib)
    message(FATAL_ERROR "imgui_glfw package conflict with original imgui")
endif()
set(scpm_glfw_version "3.2.1" CACHE STRING "")
scpm_install(glfw)
scpm_install(freetype)
scpm_install(glm)
scpm_install(stb)
if (NOT scpm_imgui_glfw_version)
    set(scpm_imgui_glfw_version "master" CACHE STRING "")
endif()
set(scpm_imgui_glfw_repo "https://github.com/pperehozhih/imgui_glfw")

if (NOT EXISTS ${scpm_work_dir}/imgui-glfw_${scpm_imgui_glfw_version}.installed)
    #scpm_clone_git("${scpm_imgui_glfw_repo}" "${scpm_imgui_glfw_version}")
    execute_process(
        COMMAND git clone --depth 1 ${scpm_imgui_glfw_repo} imgui-glfw_${scpm_imgui_glfw_version} -b ${scpm_imgui_glfw_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_clone_git_result
    )

    message("[SCPM] clone repos ${scpm_work_dir}/imgui-glfw_${scpm_imgui_glfw_version}/")
    execute_process(
        COMMAND git clone -b v1.85 --depth 1 https://github.com/ocornut/imgui
        WORKING_DIRECTORY ${scpm_work_dir}/imgui-glfw_${scpm_imgui_glfw_version}
        RESULT_VARIABLE scpm_clone_git_result
    )
    if (NOT scpm_clone_git_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos https://github.com/ocornut/imgui")
    endif()
    scpm_build_cmake("${scpm_work_dir}/imgui-glfw_${scpm_imgui_glfw_version}" "-DCMAKE_CXX_FLAGS='-I${scpm_root_dir}/include -I${scpm_root_dir}/include/freetype2'")
    file(WRITE ${scpm_work_dir}/imgui-glfw_${scpm_imgui_glfw_version}.installed "")
endif()

set(scpm_imgui_glfw_lib
    imgui_glfw
    CACHE STRING ""
)
set(scpm_imgui_glfw_lib_debug
    imgui_glfwd
    CACHE STRING ""
)

set(scpm_imgui_glfw_depends
    glfw
    freetype
    glm
    CACHE STRING ""
)
