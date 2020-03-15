if (NOT scpm_SDL_version)
    set(scpm_SDL_version "2.0.8" CACHE STRING "")
endif()
set(scpm_SDL_repo "https://github.com/SDL-mirror/SDL")

if (NOT EXISTS ${scpm_work_dir}/SDL-${scpm_SDL_version}.installed)
    scpm_download_github_archive("${scpm_SDL_repo}" "release-${scpm_SDL_version}")
    if (scpm_platform_macos)
        # Patch CMakeLists for postfix shared library macos
        file(READ "${scpm_work_dir}/SDL-release-${scpm_SDL_version}/CMakeLists.txt" cmakefile_content)
        string(REPLACE "SDL2.framework/Resources"
            "lib/cmake/SDL2" cmakefile_content "${cmakefile_content}")
        file(WRITE "${scpm_work_dir}/SDL-release-${scpm_SDL_version}/CMakeLists.txt" "${cmakefile_content}")
    endif()
    scpm_build_cmake("${scpm_work_dir}/SDL-release-${scpm_SDL_version}")
    file(WRITE ${scpm_work_dir}/SDL-${scpm_SDL_version}.installed "")
endif()

set(scpm_SDL_lib
    SDL2
)

set(scpm_SDL_lib_debug
    SDL2d
)

set(scpm_SDL_depends
    ""
    CACHE STRING ""
)

if(scpm_platform_macos)
    set(scpm_SDL_lib ${scpm_SDL_lib}
        "-framework  CoreFoundation"
        "-framework  AppKit"
        "-framework  OpenGL"
        "-framework  IOKit"
        "-framework  Cocoa"
        "-framework  Carbon"
        "-ObjC"
    )
endif()

set(scpm_SDL_lib ${scpm_SDL_lib}
    CACHE STRING ""
)

set(scpm_SDL_lib_debug ${scpm_SDL_lib_debug}
    CACHE STRING ""
}
)
