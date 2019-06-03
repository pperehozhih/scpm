if (NOT sfml_version)
    set(sfml_version "2.5.1" CACHE STRING "")
endif()
set(sfml_repo "https://github.com/SFML/SFML")

if (NOT EXISTS ${scpm_work_dir}/SFML-${sfml_version}.installed)
    scpm_download_github_archive("${sfml_repo}" "${sfml_version}")
    set(sfml_build_flags
#        -DBUILD_SHARED_LIBS=NO
        -DCMAKE_INSTALL_PREFIX=${scpm_root_dir}
        -DSFML_MISC_INSTALL_PREFIX=${scpm_root_dir}/share/SFML
        -DSFML_DEPENDENCIES_INSTALL_PREFIX=${scpm_root_dir}/Frameworks
    )
    scpm_build_cmake("${scpm_work_dir}/SFML-${sfml_version}" "${sfml_build_flags}")
    file(WRITE ${scpm_work_dir}/SFML-${sfml_version}.installed "")
endif()

set(sfml_lib
    sfml-audio
    sfml-graphics
    sfml-network
    sfml-system
    sfml-window
    CACHE STRING ""
)

set(sfml_lib_debug
    sfml-audio-s
    sfml-graphics-s
    sfml-network-s
    sfml-system-s
    sfml-window-s
    CACHE STRING ""
)
