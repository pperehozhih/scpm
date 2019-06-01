set(IMGUI_VERSION "1.69")
set(IMGUI_REPO "https://github.com/ocornut/imgui")

if (NOT EXISTS ${SCPM_WORK_DIR}/imgui)
        scpm_download_github_archive(${IMGUI_REPO} "v${IMGUI_VERSION}")
        # execute_process(
        #         COMMAND ${CMAKE_COMMAND} -E make_directory "${SCPM_WORK_DIR}/imgui/build"
        #         WORKING_DIRECTORY "${SCPM_WORK_DIR}/imgui"
        # )
        # file(DOWNLOAD "${scpm_server}/packages/${package_name}.cmake" "${SCPM_WORK_DIR}/imgui/CMakeLists.txt")
        # execute_process(
        #         COMMAND ${CMAKE_COMMAND} .. -G "${CMAKE_GENERATOR}" -DCMAKE_INSTALL_PREFIX=${SCPM_ROOT_DIR}
        #         WORKING_DIRECTORY "${SCPM_WORK_DIR}/imgui/build"
        # )
        # execute_process(
        #         COMMAND ${CMAKE_COMMAND} --build . --target install --config Release
        #         WORKING_DIRECTORY "${SCPM_WORK_DIR}/imgui/build"
        # )
endif()
