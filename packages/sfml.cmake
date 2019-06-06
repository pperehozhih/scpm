if (NOT scpm_sfml_version)
    set(scpm_sfml_version "2.5.1" CACHE STRING "")
endif()
if (scpm_platform_android)
    scpm_install(freetype)
    scpm_install(vorbis)
    scpm_install(flac)
    scpm_install(openal_soft)
endif()
set(scpm_sfml_repo "https://github.com/SFML/SFML")

if (NOT EXISTS ${scpm_work_dir}/SFML-${scpm_sfml_version}.installed)
    scpm_download_github_archive("${scpm_sfml_repo}" "${scpm_sfml_version}")
    set(sfml_build_flags
        -DCMAKE_INSTALL_PREFIX=${scpm_root_dir}
        -DSFML_MISC_INSTALL_PREFIX=${scpm_root_dir}/share/SFML
        -DSFML_DEPENDENCIES_INSTALL_PREFIX=${scpm_root_dir}/Frameworks
        -DSFML_USE_SYSTEM_DEPS=ON
    )
    # Patch CMakeLists for android install location
    file(READ "${scpm_work_dir}/SFML-${scpm_sfml_version}/CMakeLists.txt" cmakefile_content)
    string(REPLACE "\${CMAKE_ANDROID_NDK}/sources/third_party/sfml"
       "${scpm_root_dir}" cmakefile_content ${cmakefile_content})
    string(REPLACE "/\${CMAKE_ANDROID_ARCH_ABI}"
       "" cmakefile_content ${cmakefile_content})
    file(WRITE "${scpm_work_dir}/SFML-${scpm_sfml_version}/CMakeLists.txt" ${cmakefile_content})
    scpm_build_cmake("${scpm_work_dir}/SFML-${scpm_sfml_version}" "${sfml_build_flags}")
    file(WRITE ${scpm_work_dir}/SFML-${scpm_sfml_version}.installed "")
endif()

set(scpm_sfml_lib
    sfml-audio
    sfml-graphics
    sfml-network
    sfml-system
    sfml-window
)

set(scpm_sfml_lib_debug
    sfml-audio-s
    sfml-graphics-s
    sfml-network-s
    sfml-system-s
    sfml-window-s
)

if (scpm_platform_android)
    set(scpm_sfml_depends
        freetype
        vorbis
        flac
        openal_soft
        CACHE STRING ""
    )
else()
    set(scpm_sfml_depends
        ""
        CACHE STRING ""
    )
endif()

if(scpm_platform_macos)
    set(scpm_sfml_lib ${scpm_sfml_lib}
        "-framework  CoreFoundation"
        "-framework  AppKit"
        "-framework  OpenGL"
        "-framework  IOKit"
        "-framework  Cocoa"
        "-framework  Carbon"
        "-ObjC"
    )
elseif (scpm_platform_windows)
    set(scpm_sfml_lib ${scpm_sfml_lib}
        "OpenGL32"
    )
    set(scpm_sfml_lib_debug ${scpm_sfml_lib_debug}
        "OpenGL32"
    )
elseif (scpm_platform_android)
    set(scpm_sfml_lib ${scpm_sfml_lib}
        android
        log 
        EGL
    )
    if (scpm_sfml_gles_one)
        set(scpm_sfml_lib ${scpm_sfml_lib}
            GLESv1_CM
        )
    else()
        set(scpm_sfml_lib ${scpm_sfml_lib}
            GLESv2
        )
    endif()
endif()

set(scpm_sfml_lib ${scpm_sfml_lib} CACHE STRING "")
set(scpm_sfml_lib_debug ${scpm_sfml_lib_debug} CACHE STRING "")
