if (NOT scpm_SDL_mixer_version)
    set(scpm_SDL_mixer_version "2.0.2" CACHE STRING "")
endif()
scpm_install(SDL)
set(scpm_SDL_mixer_repo "https://github.com/SDL-mirror/SDL_mixer")

if (NOT EXISTS ${scpm_work_dir}/SDL_mixer-${scpm_SDL_mixer_version}.installed)
    scpm_download_github_archive("${scpm_SDL_mixer_repo}" "release-${scpm_SDL_mixer_version}")
    file(DOWNLOAD "${scpm_server}/packages/SDL_mixer.cmake.in" "${scpm_work_dir}/SDL_mixer-release-${scpm_SDL_mixer_version}/CMakeLists.txt")
    scpm_build_cmake("${scpm_work_dir}/SDL_mixer-release-${scpm_SDL_mixer_version}")
    file(WRITE ${scpm_work_dir}/SDL_mixer-${scpm_SDL_mixer_version}.installed "")
endif()

set(scpm_SDL_mixer_lib
    SDL_mixer
    CACHE STRING ""
)

set(scpm_SDL_mixer_lib_debug
    SDL_mixerd
    CACHE STRING ""
)

set(scpm_SDL_mixer_depends
    SDL
    CACHE STRING ""
)
