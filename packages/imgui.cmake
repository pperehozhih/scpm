set(IMGUI_VERSION "1.69")
set(IMGUI_REPO "https://github.com/ocornut/imgui")

if (NOT EXISTS ${SCPM_WORK_DIR}/imgui)
        file(DOWNLOAD "${IMGUI_REPO}/archive/v${IMGUI_VERSION}.zip" "${SCPM_WORK_DIR}/imgui-${IMGUI_VERSION}.zip")
        execute_process(
                COMMAND ${CMAKE_COMMAND} -E tar xzf "${SCPM_WORK_DIR}/imgui-${IMGUI_VERSION}.zip"
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )
        execute_process(
                COMMAND ${CMAKE_COMMAND} -E rename "${SCPM_WORK_DIR}/imgui-${IMGUI_VERSION}" "${SCPM_WORK_DIR}/imgui"
        )
        execute_process(
                COMMAND ${CMAKE_COMMAND} -E make_directory "${SCPM_WORK_DIR}/imgui/build"
                WORKING_DIRECTORY "${SCPM_WORK_DIR}/imgui"
        )
        file(DOWNLOAD "${scpm_server}/packages/${package_name}.cmake" "${SCPM_WORK_DIR}/imgui/CMakeLists.txt")
        execute_process(
                COMMAND ${CMAKE_COMMAND} .. -G "${CMAKE_GENERATOR}" -DCMAKE_INSTALL_PREFIX=${SCPM_ROOT_DIR}
                WORKING_DIRECTORY "${SCPM_WORK_DIR}/imgui/build"
        )
        execute_process(
                COMMAND ${CMAKE_COMMAND} --build . --target install --config Release
                WORKING_DIRECTORY "${SCPM_WORK_DIR}/imgui/build"
        )
endif()
