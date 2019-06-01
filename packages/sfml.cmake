if (NOT sfml_version)
        set(sfml_version "2.5.1")
endif()
set(sfml_repo "https://github.com/SFML/SFML")

if (NOT EXISTS ${SCPM_WORK_DIR}/libexpat-${expat_version})
        scpm_download_github_archive("${sfml_repo}" "${sfml_version}")
        set(sfml_build_flags
            -DBUILD_SHARED_LIBS=NO
            -DCMAKE_INSTALL_PREFIX=${scpm_root_dir}
            -DSFML_MISC_INSTALL_PREFIX=${scpm_root_dir}/share/SFML
            -DSFML_DEPENDENCIES_INSTALL_PREFIX=${scpm_root_dir}/Library/Frameworks
        )
        scpm_build_cmake("${scpm_work_dir}/SFML-${sfml_version}" "${sfml_build_flags}")
endif()
