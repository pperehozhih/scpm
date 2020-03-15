if (NOT scpm_server_branch)
    set(scpm_server_branch "master")
endif()
if (NOT scpm_server)
    set(scpm_server "https://raw.githubusercontent.com/pperehozhih/scpm/${scpm_server_branch}")
endif()
if (NOT scpm_work_dir)
    set(scpm_work_dir ${CMAKE_CURRENT_BINARY_DIR}/scpm)
endif()
if (NOT scpm_root_dir)
    set(scpm_root_dir ${CMAKE_CURRENT_BINARY_DIR}/root)
endif()

function(scpm_download_and_extract_archive url filename)
    message("[SCPM] download archive ${url}/${filename} to ${scpm_work_dir}/${filename}")
    file(DOWNLOAD ${url}/${filename} ${scpm_work_dir}/${filename})
    message("[SCPM] extract archive ${scpm_work_dir}/${filename}")
    execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xzf ${scpm_work_dir}/${filename}
            WORKING_DIRECTORY ${scpm_work_dir}
            RESULT_VARIABLE scpm_download_and_extract_archive_result
    )
    if (NOT scpm_download_and_extract_archive_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot extract archive ${scpm_work_dir}/${filename}")
    endif()
    message("[SCPM] remove archive ${scpm_work_dir}/${filename}")
    file(REMOVE ${scpm_work_dir}/${filename})
endfunction(scpm_download_and_extract_archive)

function(scpm_download_github_archive url filename)
    message("[SCPM] download archive ${url}/archive/${filename}.zip to ${scpm_work_dir}/${filename}.zip")
    file(DOWNLOAD ${url}/archive/${filename}.zip ${scpm_work_dir}/${filename}.zip)
    message("[SCPM] extract archive ${scpm_work_dir}/${filename}.zip")
    execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xzf ${scpm_work_dir}/${filename}.zip
            WORKING_DIRECTORY ${scpm_work_dir}
            RESULT_VARIABLE scpm_download_github_archive_result
    )
    if (NOT scpm_download_github_archive_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot extract archive ${scpm_work_dir}/${filename}.zip")
    endif()
    message("[SCPM] remove archive ${scpm_work_dir}/${filename}.zip")
    file(REMOVE ${scpm_work_dir}/${filename}.zip)
endfunction(scpm_download_github_archive)

function(scpm_clone_git url branch)
    if (NOT branch)
        set(branch "master")
    endif()
    message("[SCPM] clone repos ${url} ${branch}")
    execute_process(
            COMMAND git clone -b ${branch} --depth 1 ${url}
            WORKING_DIRECTORY ${scpm_work_dir}
            RESULT_VARIABLE scpm_clone_git_result
    )
    if (NOT scpm_clone_git_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_work_dir} ${url}")
    endif()
endfunction(scpm_clone_git)

function(scpm_clone_git_submodule_update directory)
    message("[SCPM] git submodule update ${directory}")
    execute_process(
            COMMAND git submodule update --init --recursive
            WORKING_DIRECTORY ${directory}
            RESULT_VARIABLE scpm_clone_git_submodule_update_result
    )
endfunction(scpm_clone_git_submodule_update)

function(scpm_build_configure)
    list(GET ARGN 0 directory)
    list(REMOVE_AT ARGN 0)
    set (buildargs ${ARGN})
    message("[SCPM] begin build ${directory} with configure")
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E make_directory "${directory}/scpm_build_dir"
        WORKING_DIRECTORY "${directory}"
    )
    set(buildargs ${buildargs} --prefix=${scpm_root_dir})
    find_program(SH_PROGRAM sh)
    if (NOT SH_PROGRAM)
        message(FATAL_ERROR "[SCPM] cannot found sh")
    endif()
    execute_process(
        COMMAND ${SH_PROGRAM} ../configure ${buildargs}
        WORKING_DIRECTORY "${directory}/scpm_build_dir"
        RESULT_VARIABLE scpm_build_configure_configure_result
    )
    if (NOT scpm_build_configure_configure_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot configure repos ${directory}")
    endif()
    execute_process(
        COMMAND make
        WORKING_DIRECTORY "${directory}/scpm_build_dir"
        RESULT_VARIABLE scpm_build_configure_make_result
    )
    if (NOT scpm_build_configure_make_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot make repos ${directory}")
    endif()
    execute_process(
        COMMAND make install
        WORKING_DIRECTORY "${directory}/scpm_build_dir"
        RESULT_VARIABLE scpm_build_configure_make_install_result
    )
    if (NOT scpm_build_configure_make_install_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot make repos ${directory}")
    endif()
endfunction(scpm_build_configure)

function(scpm_build_cmake)
    list(GET ARGN 0 directory)
    list(REMOVE_AT ARGN 0)
    set (buildargs ${ARGN})
    message("[SCPM] begin build ${directory} for ${CMAKE_SYSTEM_NAME}")
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E make_directory "${directory}/scpm_build_dir"
        WORKING_DIRECTORY "${directory}"
    )
    if (CMAKE_TOOLCHAIN_FILE)
        get_filename_component(CMAKE_TOOLCHAIN_FILE_ABSOLTE
                               "${CMAKE_TOOLCHAIN_FILE}"
                                ABSOLUTE)
        set(buildargs ${buildargs} "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE_ABSOLTE}")
    endif()
    if (ANDROID_ABI)
        set(buildargs ${buildargs} "-DANDROID_ABI=${ANDROID_ABI}")
    endif()
    if (ANDROID_STL)
        set(buildargs ${buildargs} "-DANDROID_STL=${ANDROID_STL}")
    endif()
    if (ANDROID_STL_FORCE_FEATURES)
        set(buildargs ${buildargs} "-DANDROID_STL_FORCE_FEATURES=ON")
    endif()
    if (ANDROID_NATIVE_API_LEVEL)
        set(buildargs ${buildargs} "-DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL}")
    endif()
    if (IOS_PLATFORM)
        set(buildargs ${buildargs} "-DIOS_PLATFORM=${IOS_PLATFORM}")
    endif()
    if (PLATFORM)
        set(buildargs ${buildargs} "-DPLATFORM=${PLATFORM}")
    endif()
    if (ARCHS)
        set(ARCHS_STRING "${ARCHS}")
        string(REPLACE ";" "\\;" ARCHS_STRING "${ARCHS}")
        set(buildargs ${buildargs} "-DARCHS=${ARCHS_STRING}")
    endif()
    message("[SCPM] begin generate ${directory} ${buildargs}")
    if (NOT scpm_platform_windows)
        execute_process(
                COMMAND ${CMAKE_COMMAND} .. -G "${CMAKE_GENERATOR}" -DCMAKE_INSTALL_PREFIX=${scpm_root_dir} -DCMAKE_BUILD_TYPE=Debug -DCMAKE_FIND_ROOT_PATH=${scpm_root_dir} ${buildargs}
                WORKING_DIRECTORY "${directory}/scpm_build_dir"
                RESULT_VARIABLE scpm_build_cmake_result
        )
        if (NOT scpm_build_cmake_result EQUAL "0")
            message(FATAL_ERROR "[SCPM] cannot generate ${directory}")
        endif()
        message("[SCPM] begin build and install ${directory}")
        execute_process(
                COMMAND ${CMAKE_COMMAND} --build . --target install --config Release
                WORKING_DIRECTORY "${directory}/scpm_build_dir"
                RESULT_VARIABLE scpm_build_cmake_result
        )
        if (NOT scpm_build_cmake_result EQUAL "0")
            message(FATAL_ERROR "[SCPM] cannot build and install ${directory}")
        endif()
    else()
        execute_process(
                COMMAND ${CMAKE_COMMAND} .. -G "${CMAKE_GENERATOR}" -DCMAKE_INSTALL_PREFIX=${scpm_root_dir} -DCMAKE_DEBUG_POSTFIX=d ${buildargs}
                WORKING_DIRECTORY "${directory}/scpm_build_dir"
                RESULT_VARIABLE scpm_build_cmake_result
        )
        if (NOT scpm_build_cmake_result EQUAL "0")
            message(FATAL_ERROR "[SCPM] cannot generate ${directory}")
        endif()
        message("[SCPM] begin build and install ${directory} Debug")
        execute_process(
                COMMAND ${CMAKE_COMMAND} --build . --target install --config Debug
                WORKING_DIRECTORY "${directory}/scpm_build_dir"
                RESULT_VARIABLE scpm_build_cmake_result
        )
        if (NOT scpm_build_cmake_result EQUAL "0")
            message(FATAL_ERROR "[SCPM] cannot build and install ${directory} Debug")
        endif()
        message("[SCPM] begin install ${directory} Release")
        execute_process(
                COMMAND ${CMAKE_COMMAND} --build . --target install --config Release
                WORKING_DIRECTORY "${directory}/scpm_build_dir"
                RESULT_VARIABLE scpm_build_cmake_result
        )
        if (NOT scpm_build_cmake_result EQUAL "0")
            message(FATAL_ERROR "[SCPM] cannot build and install ${directory} Release")
        endif()
    endif()
endfunction(scpm_build_cmake)


function(scpm_install package_name)
    if (NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/scpm/${package_name}.cmake)
        message("[SCPM] download file ${scpm_server}/packages/${package_name}.cmake")
        file(DOWNLOAD ${scpm_server}/packages/${package_name}.cmake ${scpm_work_dir}/${package_name}.cmake)
    endif()
    include(${scpm_work_dir}/${package_name}.cmake)
endfunction(scpm_install)

function(scpm_link_target)
    set(options "")
    set(one_value_args TARGET)
    set(multi_value_args LIBS)
    cmake_parse_arguments(scpm_link_target "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    set(dependencies "")
    foreach(lib ${scpm_link_target_LIBS})
        set(dependencies ${dependencies} ${lib})
        foreach(depends ${scpm_${lib}_depends})
            set(dependencies ${dependencies} ${depends})
        endforeach(depends ${scpm_${lib}_depends})
        
    endforeach(lib ${scpm_link_target_LIBS})
    list(REMOVE_DUPLICATES dependencies)
    set(linklibs "")
    foreach(lib ${dependencies})
        if (scpm_platform_windows)
            foreach(depends ${scpm_${lib}_lib})
                target_link_libraries(${scpm_link_target_TARGET} optimized ${depends})
            endforeach(depends ${scpm_${lib}_lib})
            foreach(depends ${scpm_${lib}_lib_debug})
                target_link_libraries(${scpm_link_target_TARGET} debug ${depends})
            endforeach(depends ${scpm_${lib}_lib})
        else(scpm_platform_windows)
            foreach(depends ${scpm_${lib}_lib})
                target_link_libraries(${scpm_link_target_TARGET} ${depends})
                message("${depends}")
            endforeach(depends ${scpm_${lib}_lib})
        endif(scpm_platform_windows)
    endforeach(lib ${dependencies})
endfunction(scpm_link_target)

if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    set(scpm_platform_windows 1)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    set(scpm_platform_linux 1)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
    if (IOS)
        set(scpm_platform_ios 1)
    else(IOS)
        set(scpm_platform_macos 1)
    endif(IOS)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "iOS")
    set(scpm_platform_ios 1)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "tvOS")
    set(scpm_platform_ios 1)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "watchOS")
    set(scpm_platform_ios 1)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Android")
    set(scpm_platform_android 1)
# else()
#     message(FATAL_ERROR "Unsupported operating system or environment")
endif()
