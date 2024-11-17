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
if (NOT scmp_build_type)
    set(scmp_build_type Release)
endif()

list(APPEND CMAKE_PREFIX_PATH "${scpm_root_dir}")

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
    include(ProcessorCount)
    ProcessorCount(scpm_cores_count)
    set(scpm_cores_count ${scpm_cores_count} CACHE STRING "")
    if (scpm_platform_windows)
        scpm_install(mingw)
    else()
        set(scpm_make_exec "make")
        set(scpm_sh_exec "sh")
    endif()
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E make_directory "${directory}/scpm_build_dir"
        WORKING_DIRECTORY "${directory}"
    )
    set(buildargs ${buildargs} --prefix=${scpm_root_dir})
    find_program(SH_PROGRAM sh)
    if (NOT SH_PROGRAM)
        message(FATAL_ERROR "[SCPM] cannot found sh")
    endif()
    if (scpm_platform_android)
        if (NOT scpm_platform_target_platform)
            set(scpm_platform_target_platform 21)
        endif()
        if(ANDROID_TOOLCHAIN_NAME MATCHES "^arm-linux-androideabi-")
            set(scpm_platform_target "armv7a-linux-androideabi${scpm_platform_target_platform}")
            set(scpm_platform_host "armv7")
        elseif(ANDROID_TOOLCHAIN_NAME MATCHES "^aarch64-linux-android-")
            set(scpm_platform_target "aarch64-linux-android${scpm_platform_target_platform}")
            set(scpm_platform_host "aarch64")
        elseif(ANDROID_TOOLCHAIN_NAME MATCHES "^x86-" OR ANDROID_TOOLCHAIN_NAME MATCHES "^i686-")
            set(scpm_platform_target "i686-linux-android${scpm_platform_target_platform}")
            set(scpm_platform_host "x86")
        elseif(ANDROID_TOOLCHAIN_NAME MATCHES "^x86_64-")
            set(scpm_platform_target "x86_64-linux-android${scpm_platform_target_platform}")
            set(scpm_platform_host "x86_64")
        else()
            set(scpm_platform_target "armv7a-linux-androideabi${scpm_platform_target_platform}")
            set(scpm_platform_host "armv7")
        endif()
        set(buildargs ${buildargs}
            "CC=${CMAKE_C_COMPILER}"
            "CXX=${CMAKE_CXX_COMPILER}"
            "CFLAGS=--sysroot=${CMAKE_SYSROOT} --target=${scpm_platform_target} ${CMAKE_C_FLAGS} -fPIC"
            "CXXFLAGS=--sysroot=${CMAKE_SYSROOT} --target=${scpm_platform_target} ${CMAKE_CXX_FLAGS} -fPIC"
            "RANLIB=${CMAKE_RANLIB}"
            "--host=${scpm_platform_host}")
    endif()
    execute_process(
        COMMAND ${scpm_sh_exec} ../configure ${buildargs}
        WORKING_DIRECTORY "${directory}/scpm_build_dir"
        RESULT_VARIABLE scpm_build_configure_configure_result
    )
    if (NOT scpm_build_configure_configure_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot configure repos ${directory}")
    endif()
    execute_process(
        COMMAND ${scpm_make_exec} -j ${scpm_cores_count}
        WORKING_DIRECTORY "${directory}/scpm_build_dir"
        RESULT_VARIABLE scpm_build_configure_make_result
    )
    if (NOT scpm_build_configure_make_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot make repos ${directory}")
    endif()
    execute_process(
        COMMAND ${scpm_make_exec} install
        WORKING_DIRECTORY "${directory}/scpm_build_dir"
        RESULT_VARIABLE scpm_build_configure_make_install_result
    )
    if (NOT scpm_build_configure_make_install_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot make repos ${directory}")
    endif()
endfunction(scpm_build_configure)

function(scpm_build_make)
    list(GET ARGN 0 directory)
    list(REMOVE_AT ARGN 0)
    set (buildargs ${ARGN})
    set(buildargs ${buildargs} DESTDIR=${scpm_root_dir})
    include(ProcessorCount)
    ProcessorCount(scpm_cores_count)
    set(scpm_cores_count ${scpm_cores_count} CACHE STRING "")
    if (scpm_platform_windows)
        scpm_install(mingw)
    else()
        set(scpm_make_exec "make")
    endif()
    message("[SCPM] -> $ENV{PATH}")
    message("[SCPM] ${scpm_make_exec} -j ${scpm_cores_count} ${buildargs}")
    execute_process(COMMAND "${scpm_make_exec}" -j "${scpm_cores_count}" ${buildargs}
        WORKING_DIRECTORY  "${directory}"
    )
    execute_process(COMMAND "${MAKE_EXEC}" install
        WORKING_DIRECTORY  "${directory}"
    )
endfunction(scpm_build_make)

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
        if (scpm_platform_macos)
            if(CMAKE_GENERATOR STREQUAL Xcode)
                execute_process(
                        COMMAND ${CMAKE_COMMAND} .. -G "${CMAKE_GENERATOR}" -DCMAKE_INSTALL_PREFIX=${scpm_root_dir} -DCMAKE_BUILD_TYPE=${scmp_build_type} -DCMAKE_FIND_ROOT_PATH=${scpm_root_dir} ${buildargs}
                        WORKING_DIRECTORY "${directory}/scpm_build_dir"
                        RESULT_VARIABLE scpm_build_cmake_result
                )
            else()
                execute_process(
                    COMMAND ${CMAKE_COMMAND} .. -G "${CMAKE_GENERATOR}" -DCMAKE_INSTALL_PREFIX=${scpm_root_dir} -DCMAKE_BUILD_TYPE=${scmp_build_type} -DCMAKE_FIND_ROOT_PATH=${scpm_root_dir} ${buildargs}
                    WORKING_DIRECTORY "${directory}/scpm_build_dir"
                    RESULT_VARIABLE scpm_build_cmake_result
                )
            endif()
        else()
            execute_process(
                    COMMAND ${CMAKE_COMMAND} .. -G "${CMAKE_GENERATOR}" -DCMAKE_INSTALL_PREFIX=${scpm_root_dir} -DCMAKE_BUILD_TYPE=${scmp_build_type} -DCMAKE_FIND_ROOT_PATH=${scpm_root_dir} ${buildargs}
                    WORKING_DIRECTORY "${directory}/scpm_build_dir"
                    RESULT_VARIABLE scpm_build_cmake_result
            )
        endif()
        if (NOT scpm_build_cmake_result EQUAL "0")
            message(FATAL_ERROR "[SCPM] cannot generate ${directory}")
        endif()
        message("[SCPM] begin build and install ${directory}")
        execute_process(
                COMMAND ${CMAKE_COMMAND} --build . --target install --config ${scmp_build_type}
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
    file(SIZE ${CMAKE_CURRENT_BINARY_DIR}/scpm/${package_name}.cmake package_file_size)
    if(package_file_size GREATER 0)
        include(${scpm_work_dir}/${package_name}.cmake)
    else()
        message(FATAL_ERROR "${scpm_work_dir}/${package_name}.cmake file is zero length")
    endif()
endfunction(scpm_install)

function(scpm_debugger_setup target)
    if (MSVC)
        set_property(TARGET ${target} PROPERTY VS_DEBUGGER_WORKING_DIRECTORY "${scpm_root_dir}/bin")
        set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${target})
    endif()
endfunction(scpm_debugger_setup)

function(scpm_create_target)
    set(options "")
    set(one_value_args TARGET)
    set(multi_value_args FILES TYPE)
    cmake_parse_arguments(scpm_create_target "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    message("${scpm_create_target_TARGET}")
    if (${scpm_create_target_TYPE} STREQUAL "GUI")
        if(MSVC)
            add_executable(${scpm_create_target_TARGET} WIN32 ${scpm_create_target_FILES})
        elseif(scpm_platform_macos)
            add_executable(${scpm_create_target_TARGET} MACOSX_BUNDLE ${scpm_create_target_FILES})
            file(GLOB scpm_root_dylibs
                "${scpm_root_dir}/lib/*.dylib"
            )
            file(COPY ${scpm_root_dylibs} DESTINATION "${scpm_root_dir}/bin/Release/${scpm_create_target_TARGET}.app/Contents/MacOS")
            file(GLOB scpm_root_dylibs
                "${scpm_root_dir}/bin/Release/${scpm_create_target_TARGET}.app/Release/Contents/MacOS/*.dylib"
            )
            install (CODE "
                include(BundleUtilities)
                fixup_bundle(\"${scpm_root_dir}/bin/Release/${scpm_create_target_TARGET}.app\" \"${scpm_root_dylibs}\" \"${scpm_root_dir}/lib\")
            " OPTIONAL)
        else()
            add_executable(${scpm_create_target_TARGET} ${scpm_create_target_FILES})
        endif()
    elseif (${scpm_create_target_TYPE} STREQUAL "LIBRARY")
        add_library(${scpm_create_target_TARGET} STATIC ${scpm_create_target_FILES})
    elseif (${scpm_create_target_TYPE} STREQUAL "SHARED")
        add_library(${scpm_create_target_TARGET} SHARED ${scpm_create_target_FILES})
    elseif (${scpm_create_target_TYPE} STREQUAL "CONSOLE")
        add_executable(${scpm_create_target_TARGET} ${scpm_create_target_FILES})
    else()
        message(FATAL_ERROR "Unknown target type ${scpm_create_target_TARGET}")
    endif()
    install(TARGETS ${scpm_create_target_TARGET}
        RUNTIME DESTINATION "${scpm_root_dir}/bin"
        LIBRARY DESTINATION "${scpm_root_dir}/lib"
    )
    set_target_properties(${scpm_create_target_TARGET}
        PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY "${scpm_root_dir}/lib"
        LIBRARY_OUTPUT_DIRECTORY "${scpm_root_dir}/lib"
        RUNTIME_OUTPUT_DIRECTORY "${scpm_root_dir}/bin"
    )
    set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR} PARENT_SCOPE)
    set( CMAKE_RUNTIME_OUTPUT_DIRECTORY "${scpm_root_dir}/bin" PARENT_SCOPE )
    set( CMAKE_LIBRARY_OUTPUT_DIRECTORY "${scpm_root_dir}/lib" PARENT_SCOPE )
    set( CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${scpm_root_dir}/lib" PARENT_SCOPE )
    # Изменение стандартных путей установки
    set(CMAKE_INSTALL_BINDIR "${scpm_root_dir}/bin" PARENT_SCOPE)
    set(CMAKE_INSTALL_LIBDIR "${scpm_root_dir}/lib" PARENT_SCOPE)
    set(CMAKE_INSTALL_INCLUDEDIR "${scpm_root_dir}/include" PARENT_SCOPE)
    foreach( OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES} )
        string( TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG )
        set( CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} "${scpm_root_dir}/bin" PARENT_SCOPE )
        set( CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} "${scpm_root_dir}/lib" PARENT_SCOPE )
        set( CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} "${scpm_root_dir}/lib" PARENT_SCOPE )
    endforeach( OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES )
    SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib" PARENT_SCOPE )

    set(last_dir "")
    set(files "")
    foreach(file ${scpm_create_target_FILES})
        get_filename_component(dir "${file}" PATH)
        message("${file}")
        if(NOT "${dir}" STREQUAL "${last_dir}")
            if(files)
                source_group("${last_dir}" FILES ${files})
            endif()
            set(files "")
        endif()
        set(files ${files} ${file})
        set(last_dir "${dir}")
    endforeach()

    if(files)
        source_group("${last_dir}" FILES ${files})
    endif()


endfunction(scpm_create_target)

function(scpm_link_target)
    set(options "")
    set(one_value_args TARGET)
    set(multi_value_args LIBS)
    cmake_parse_arguments(scpm_link_target "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    set(dependencies "")
    set(childrens ${scpm_link_target_LIBS})
    list(LENGTH childrens length)
    while(0 LESS ${length})
        list(GET childrens 0 lib)
        list(POP_FRONT childrens)
        list(APPEND childrens ${scpm_${lib}_depends})
        set(dependencies ${dependencies} ${lib})
        list(LENGTH childrens length)
    endwhile()
    list(REMOVE_DUPLICATES dependencies)
    set(linklibs "")
    foreach(lib ${dependencies})
        if (scpm_platform_windows)
            foreach(depends ${scpm_${lib}_lib})
                message("${depends}")
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
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Emscripten")
    set(scpm_platform_emscripten 1)
# else()
#     message(FATAL_ERROR "Unsupported operating system or environment")
endif()

message("Build for platform ${CMAKE_SYSTEM_NAME}")
