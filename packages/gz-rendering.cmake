if (NOT scpm_gz_rendering_version)
    set(scpm_gz_rendering_version_major "9" CACHE STRING "")
    set(scpm_gz_rendering_version "${scpm_gz_rendering_version_major}.1.0" CACHE STRING "")
endif()
set(scpm_gz_rendering_repo "https://github.com/gazebosim/gz-rendering")

scpm_install(ogre-next)

if (NOT EXISTS ${scpm_work_dir}/gz_rendering-${scpm_gz_rendering_version_major}-${scpm_gz_rendering_version}.installed)
    scpm_download_github_archive("${scpm_gz_rendering_repo}" "gz-rendering${scpm_gz_rendering_version_major}_${scpm_gz_rendering_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-rendering-gz-rendering${scpm_gz_rendering_version_major}_${scpm_gz_rendering_version}")
    file(WRITE ${scpm_work_dir}/gz_rendering-${scpm_gz_rendering_version_major}-${scpm_gz_rendering_version}.installed)
endif()
set(scpm_gz_rendering_lib
    gz_rendering
    CACHE STRING ""
)
set(scpm_gz_rendering_lib_debug
    gz_renderingd
    CACHE STRING ""
)
set(scpm_gz_rendering_depends
    CACHE STRING ""
)
