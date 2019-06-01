if (NOT scpm_server)
    set(scpm_server "https://raw.githubusercontent.com/pperehozhih/scpm/master")
endif()

function(scpm_download_github_archive url filename)
    file(DOWNLOAD ${url}/archives/${filename}.zip ${SCPM_WORK_DIR}/${filename}.zip)
    execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xzf ${SCPM_WORK_DIR}/${filename}.zip
            WORKING_DIRECTORY ${SCPM_WORK_DIR}
    )
endfunction(scpm_download)

function(scpm_install package_name package_version)
    set(SCPM_WORK_DIR ${CMAKE_CURRENT_BINARY_DIR}/scpm)
    set(SCPM_ROOT_DIR ${CMAKE_CURRENT_BINARY_DIR}/root)
    if (NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/scpm/${package_name}${package_version}.cmake)
        file(DOWNLOAD ${scpm_server}/packages/${package_name}.cmake ${SCPM_WORK_DIR}/${package_name}${package_version}.cmake)
        include(${SCPM_WORK_DIR}/${package_name}${package_version}.cmake)
    endif()
endfunction(scpm_install)
