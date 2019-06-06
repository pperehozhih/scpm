if (NOT scpm_SDL_version)
    set(scpm_SDL_version "2.0.8" CACHE STRING "")
endif()
set(scpm_SDL_repo "https://github.com/SDL-mirror/SDL")

if (NOT EXISTS ${scpm_work_dir}/SDL-${scpm_SDL_version}.installed)
    scpm_clone_git("${scpm_SDL_repo}" "release-${scpm_SDL_version}")
    scpm_build_cmake("${scpm_work_dir}/glm-${glm_version}")
    file(WRITE ${scpm_work_dir}/SDL-${scpm_SDL_version}.installed "")
endif()

set(scpm_SDL_lib
    SDL
    CACHE STRING ""
)

set(scpm_SDL_lib_debug
    SDLd
    CACHE STRING ""
)

set(scpm_SDL_depends
    ""
    CACHE STRING ""
)
