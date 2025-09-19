if (scpm_imgui_lib)
    message(FATAL_ERROR "imgui_sdl2 package conflict with original imgui")
endif()
#set(scpm_sdl2_version "3.2.1" CACHE STRING "")
if (NOT scpm_imgui_sdl2_skip_sdl)
    scpm_install(SDL)
endif()
if (NOT scpm_imgui_sdl2_skip_ft)
    scpm_install(freetype)
endif()
scpm_install(glm)
scpm_install(stb)
if (NOT scpm_imgui_sdl2_version)
    set(scpm_imgui_sdl2_version "master" CACHE STRING "")
endif()
if (NOT scpm_imgui_sdl2_imgui_version)
    set(scpm_imgui_sdl2_imgui_version "v1.91.8" CACHE STRING "")
endif()
set(scpm_imgui_sdl2_repo "https://github.com/pperehozhih/imgui_sdl2")

if (NOT EXISTS ${scpm_work_dir}/imgui-sdl2_${scpm_imgui_sdl2_version}.installed)
    #scpm_clone_git("${scpm_imgui_sdl2_repo}" "${scpm_imgui_sdl2_version}")
    execute_process(
        COMMAND git clone -b ${scpm_imgui_sdl2_version} --depth 1 ${scpm_imgui_sdl2_repo} imgui-sdl2_${scpm_imgui_sdl2_version} 
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_clone_git_result
    )

    message("[SCPM] clone repos ${scpm_work_dir}/imgui-sdl2_${scpm_imgui_sdl2_version}/")
    execute_process(
        COMMAND git clone -b ${scpm_imgui_sdl2_imgui_version} --depth 1 https://github.com/ocornut/imgui
        WORKING_DIRECTORY ${scpm_work_dir}/imgui-sdl2_${scpm_imgui_sdl2_version}
        RESULT_VARIABLE scpm_clone_git_result
    )
    if (NOT scpm_clone_git_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos https://github.com/ocornut/imgui")
    endif()
    scpm_build_cmake("${scpm_work_dir}/imgui-sdl2_${scpm_imgui_sdl2_version}" "-DCMAKE_CXX_FLAGS='-I${scpm_root_dir}/include -I${scpm_root_dir}/include/freetype2'")
    file(WRITE ${scpm_work_dir}/imgui-sdl2_${scpm_imgui_sdl2_version}.installed "")
endif()

set(scpm_imgui_sdl2_lib
    imgui_sdl2
    CACHE STRING ""
)
set(scpm_imgui_sdl2_lib_debug
    imgui_sdl2d
    CACHE STRING ""
)

set(scpm_imgui_sdl2_depends
    SDL
    freetype
    glm
    CACHE STRING ""
)
