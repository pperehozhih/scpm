if (NOT expat_version)
        set(expat_version "R_2_2_6")
endif()
set(expat_repo "https://github.com/libexpat/libexpat")

if (NOT EXISTS ${SCPM_WORK_DIR}/libexpat-${expat_version})
        scpm_download_github_archive("${expat_repo}" "${expat_version}")
        scpm_build_cmake("${scpm_work_dir}/libexpat-${expat_version}/expat" "-DBUILD_shared=OFF")
endif()
