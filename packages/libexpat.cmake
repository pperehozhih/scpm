set(EXPAT_VERSION "R_2_2_6")
set(EXPAT_REPO "https://github.com/libexpat/libexpat")

if (NOT EXISTS ${SCPM_WORK_DIR}/libexpat)
        file(DOWNLOAD "${EXPAT_REPO}/archive/${EXPAT_VERSION}.zip" "${SCPM_WORK_DIR}/expat-${EXPAT_VERSION}.zip")
        execute_process(
                COMMAND ${CMAKE_COMMAND} -E tar xzf "${SCPM_WORK_DIR}/expat-${EXPAT_VERSION}.zip"
                WORKING_DIRECTORY ${SCPM_WORK_DIR}
        )
        execute_process(
                COMMAND ${CMAKE_COMMAND} -E rename "${SCPM_WORK_DIR}/libexpat-${EXPAT_VERSION}" "${SCPM_WORK_DIR}/expat"
        )
        execute_process(
                COMMAND ${CMAKE_COMMAND} -E make_directory "${SCPM_WORK_DIR}/expat/build"
                WORKING_DIRECTORY "${SCPM_WORK_DIR}/expat"
        )
        execute_process(
                COMMAND ${CMAKE_COMMAND} ../expat  -G "${CMAKE_GENERATOR}" -DBUILD_SHARED_LIBS=NO -DCMAKE_INSTALL_PREFIX=${SCPM_ROOT_DIR}
                WORKING_DIRECTORY "${SCPM_WORK_DIR}/expat/build"
        )
        execute_process(
                COMMAND ${CMAKE_COMMAND} --build . --target install --config Release
                WORKING_DIRECTORY "${SCPM_WORK_DIR}/expat/build"
        )
endif()
