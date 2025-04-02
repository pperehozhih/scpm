https://github.com/mirror/ncurses/archive/refs/tags/v6.4.zip

if (NOT scpm_ncurses_version)
    set(scpm_ncurses_version "6.4" CACHE STRING "")
endif()
set(scpm_ncurses_repo "https://github.com/mirror/ncurses")

if (NOT EXISTS ${scpm_work_dir}/ncurses-${scpm_ncurses_version}.installed)
    scpm_download_github_archive("${scpm_ncurses_repo}" "v${scpm_ncurses_version}")
    scpm_build_configure("${scpm_work_dir}/xz-${scpm_ncurses_version}")
    file(WRITE ${scpm_work_dir}/ncurses-${scpm_ncurses_version}.installed)
endif()

set(scpm_ncurses_lib
    ncurses
    CACHE STRING ""
)
set(scpm_ncurses_lib_debug
    ncursesd
    CACHE STRING ""
)
set(scpm_ncurses_depends
    CACHE STRING ""
)
