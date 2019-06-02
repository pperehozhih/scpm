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
    message("[SCPM] clone repos ${url}")
    execute_process(
            COMMAND git clone -b ${branch} --depth 1 ${url}
            WORKING_DIRECTORY ${scpm_work_dir}
            RESULT_VARIABLE scpm_clone_git_result
    )
    if (NOT scpm_clone_git_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_work_dir} ${url}")
    endif()
endfunction(scpm_clone_git)

function(scpm_build_cmake directory buildargs)
    message("[SCPM] begin build ${directory}")
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E make_directory "${directory}/build"
        WORKING_DIRECTORY "${directory}"
    )
    message("[SCPM] begin generate ${directory}")
    if (NOT MSVC)
        execute_process(
                COMMAND ${CMAKE_COMMAND} .. -G "${CMAKE_GENERATOR}" -DCMAKE_INSTALL_PREFIX=${scpm_root_dir} -DCMAKE_BUILD_TYPE=Release ${buildargs}
                WORKING_DIRECTORY "${directory}/build"
                RESULT_VARIABLE scpm_build_cmake_result
        )
        if (NOT scpm_build_cmake_result EQUAL "0")
            message(FATAL_ERROR "[SCPM] cannot generate ${directory}")
        endif()
        message("[SCPM] begin build and install ${directory}")
        execute_process(
                COMMAND ${CMAKE_COMMAND} --build . --target install --config Release
                WORKING_DIRECTORY "${directory}/build"
                RESULT_VARIABLE scpm_build_cmake_result
        )
        if (NOT scpm_build_cmake_result EQUAL "0")
            message(FATAL_ERROR "[SCPM] cannot build and install ${directory}")
        endif()
    else()
        execute_process(
                COMMAND ${CMAKE_COMMAND} .. -G "${CMAKE_GENERATOR}" -DCMAKE_INSTALL_PREFIX=${scpm_root_dir} -DCMAKE_DEBUG_POSTFIX=d ${buildargs}
                WORKING_DIRECTORY "${directory}/build"
                RESULT_VARIABLE scpm_build_cmake_result
        )
        if (NOT scpm_build_cmake_result EQUAL "0")
            message(FATAL_ERROR "[SCPM] cannot generate ${directory}")
        endif()
        message("[SCPM] begin build and install ${directory} Debug")
        execute_process(
                COMMAND ${CMAKE_COMMAND} --build . --target install --config Debug
                WORKING_DIRECTORY "${directory}/build"
                RESULT_VARIABLE scpm_build_cmake_result
        )
        if (NOT scpm_build_cmake_result EQUAL "0")
            message(FATAL_ERROR "[SCPM] cannot build and install ${directory} Debug")
        endif()
        message("[SCPM] begin install ${directory} Release")
        execute_process(
                COMMAND ${CMAKE_COMMAND} --build . --target install --config Release
                WORKING_DIRECTORY "${directory}/build"
                RESULT_VARIABLE scpm_build_cmake_result
        )
        if (NOT scpm_build_cmake_result EQUAL "0")
            message(FATAL_ERROR "[SCPM] cannot build and install ${directory} Release")
        endif()
    endif()
endfunction(scpm_build_cmake)


function(scpm_install package_name package_version)
    if (NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/scpm/${package_name}${package_version}.cmake)
        message("[SCPM] download file ${scpm_server}/packages/${package_name}.cmake")
        file(DOWNLOAD ${scpm_server}/packages/${package_name}.cmake ${scpm_work_dir}/${package_name}${package_version}.cmake)
        if (package_version)
            set("${package_name}_version" ${package_version})
        endif()
        include(${scpm_work_dir}/${package_name}${package_version}.cmake)
    endif()
endfunction(scpm_install)
