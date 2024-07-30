if (NOT scpm_glm_version)
        set(scpm_glm_version "1.0.1" CACHE STRING "")
endif()
set(scpm_glm_repo "https://github.com/g-truc/glm")

if (NOT EXISTS ${scpm_work_dir}/glm-${scpm_glm_version}.installed)
    scpm_download_github_archive("${scpm_glm_repo}" "${scpm_glm_version}")
    scpm_build_cmake("${scpm_work_dir}/glm-${scpm_glm_version}" "-DGLM_TEST_ENABLE=OFF")
    file(WRITE ${scpm_work_dir}/glm-${scpm_glm_version}.installed)
endif()
