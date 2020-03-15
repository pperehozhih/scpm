if (NOT scpm_nblood_version)
    set(scpm_nblood_version "1.01" CACHE STRING "")
endif()
scpm_install(vpx)
scpm_install(png)
scpm_install(mpg123)
scpm_install(vorbis)
scpm_install(SDL_mixer)
set(scpm_nblood_repo "https://github.com/nukeykt/NBlood")

if (NOT EXISTS ${scpm_work_dir}/nblood-${scpm_nblood_version}.installed)
    scpm_download_github_archive("${scpm_nblood_repo}" "v${scpm_nblood_version}")
    file(DOWNLOAD "${scpm_server}/packages/nblood.cmake.in" "${scpm_work_dir}/NBlood-${scpm_nblood_version}/CMakeLists.txt")
    scpm_build_cmake("${scpm_work_dir}/NBlood-${scpm_nblood_version}")
    file(WRITE ${scpm_work_dir}/nblood-${scpm_nblood_version}.installed)
endif()

set(scpm_nblood_lib
    nblood
    CACHE STRING ""
)
set(scpm_nblood_lib_debug
    nbloodd
    CACHE STRING ""
)
set(scpm_nblood_depends
    CACHE STRING ""
)
