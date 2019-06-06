if (scpm_imgui_lib)
    message(FATAL_ERROR "imgui_sfml package conflict with original imgui")
endif()
if (scpm_sfml_lib)
    message(FATAL_ERROR "imgui_sfml package conflict with original sfml")
endif()
set(scpm_sfml_gles_one 1 CACHE STRING "")
scpm_install(sfml)
if (NOT scpm_imgui_sfml_version)
    set(scpm_imgui_sfml_version "2.0.1" CACHE STRING "")
endif()
set(scpm_imgui_sfml_repo "https://github.com/eliasdaler/imgui-sfml")

if (NOT EXISTS ${scpm_work_dir}/imgui-sfml_${scpm_imgui_sfml_version}.installed)
    scpm_clone_git("${scpm_imgui_sfml_repo}" "v${scpm_imgui_sfml_version}")
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E rename "${scpm_work_dir}/imgui-sfml" "${scpm_work_dir}/imgui-sfml_${scpm_imgui_sfml_version}"
    )
    file(DOWNLOAD "${scpm_server}/packages/${package_name}.cmake.in" "${scpm_work_dir}/imgui-sfml_${scpm_imgui_sfml_version}/internal/CMakeLists.txt")
    message("[SCPM] clone repos ${url}")
    execute_process(
        COMMAND git clone -b v1.70 --depth 1 https://github.com/ocornut/imgui
        WORKING_DIRECTORY ${scpm_work_dir}/imgui-sfml_${scpm_imgui_sfml_version}/internal/
        RESULT_VARIABLE scpm_clone_git_result
    )
    if (NOT scpm_clone_git_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos https://github.com/ocornut/imgui")
    endif()
    scpm_build_cmake("${scpm_work_dir}/imgui-sfml_${scpm_imgui_sfml_version}/internal" "-DCMAKE_CXX_FLAGS=-I${scpm_root_dir}/include")
    file(WRITE ${scpm_work_dir}/imgui-sfml_${scpm_imgui_sfml_version}.installed "")
endif()

set(scpm_imgui_sfml_lib
    imgui_sfml
    CACHE STRING ""
)
set(scpm_imgui_sfml_lib_debug
    imgui_sfmld
    CACHE STRING ""
)

set(scpm_imgui_sfml_depends
    sfml
    CACHE STRING ""
)
