if (NOT glm_version)
        set(glm_version "0.9.9.5" CACHE STRING "")
endif()
set(glm_repo "https://github.com/g-truc/glm")

if (NOT EXISTS ${scpm_work_dir}/glm-${glm_version})
        scpm_download_github_archive("${glm_repo}" "${glm_version}")
        scpm_build_cmake("${scpm_work_dir}/glm-${glm_version}" "-DGLM_TEST_ENABLE=OFF")
endif()
