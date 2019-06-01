set(EXPAT_VERSION "R_2_2_6")

if (NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/libexpat)
        file(DOWNLOAD "https://github.com/libexpat/libexpat/archive/${EXPAT_VERSION}.zip" "${CMAKE_CURRENT_BINARY_DIR}/expat-${EXPAT_VERSION}.zip")
        execute_process(
                COMMAND ${CMAKE_COMMAND} -E tar xzf "${CMAKE_CURRENT_BINARY_DIR}/expat-${EXPAT_VERSION}.zip"
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )
        execute_process(
                COMMAND ${CMAKE_COMMAND} -E rename "${CMAKE_CURRENT_BINARY_DIR}/libexpat-${EXPAT_VERSION}" "${CMAKE_CURRENT_BINARY_DIR}/expat"
        )
        execute_process(
                COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_CURRENT_BINARY_DIR}/expat/build"
                WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/expat"
        )
        execute_process(
                COMMAND ${CMAKE_COMMAND} ../expat  -G "${CMAKE_GENERATOR}" -DBUILD_SHARED_LIBS=NO -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/3rd
                WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/expat/build"
        )
        execute_process(
                COMMAND ${CMAKE_COMMAND} --build . --target install --config Release
                WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/expat/build"
        )
endif()
