if (NOT scpm_boost_version)
        set(scpm_boost_version "1.84.0" CACHE STRING "")
endif()
set(scpm_boost_repo "https://github.com/boostorg/boost")

if (NOT EXISTS ${scpm_work_dir}/boost-${scpm_boost_version}.installed)
    # scpm_download_github_archive("${scpm_boost_repo}" "boost-${scpm_boost_version}")
    execute_process(
        COMMAND git clone -b boost-${scpm_boost_version} --depth 1 ${scpm_boost_repo} boost-${scpm_boost_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_clone_git_result
    )
    #if (NOT scpm_clone_git_result EQUAL "0")
    #    message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_boost_repo}")
    #endif()
    scpm_clone_git_submodule_update("${scpm_work_dir}/boost-${scpm_boost_version}")
    if (NOT ${BOOST_ENABLE_PYTHON})
        scpm_build_cmake("${scpm_work_dir}/boost-${scpm_boost_version}" "-DBOOST_LOCALE_ENABLE_ICU=OFF")
    else()
        scpm_build_cmake("${scpm_work_dir}/boost-${scpm_boost_version}" "-DBOOST_ENABLE_PYTHON=ON" "-DPython_ROOT_DIR=\"${PYTHON_ROOT_DIR}\"" "-DBOOST_LOCALE_ENABLE_ICU=OFF")
    endif()
    file(WRITE ${scpm_work_dir}/boost-${scpm_boost_version}.installed)
endif()
