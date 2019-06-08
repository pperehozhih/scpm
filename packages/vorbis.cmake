if (NOT scpm_vorbis_version)
    set(scpm_vorbis_version "1.3.6" CACHE STRING "")
endif()
scpm_install(ogg)
set(scpm_vorbis_repo "https://github.com/xiph/vorbis")

if (NOT EXISTS ${scpm_work_dir}/vorbis-${scpm_vorbis_version}.installed)
    scpm_download_github_archive("${scpm_vorbis_repo}" "v${scpm_vorbis_version}")
    scpm_build_cmake("${scpm_work_dir}/vorbis-${scpm_vorbis_version}")
    file(WRITE ${scpm_work_dir}/vorbis-${scpm_vorbis_version}.installed "")
endif()

set(scpm_vorbis_lib
    vorbis
    CACHE STRING ""
)
set(scpm_vorbis_lib_debug
    vorbisd
    CACHE STRING ""
)
set(scpm_vorbis_depends
    ""
    CACHE STRING ""
)
