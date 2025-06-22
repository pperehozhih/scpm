if (NOT scpm_gz_physics_version)
    set(scpm_gz_physics_version_major "8" CACHE STRING "")
    set(scpm_gz_physics_version "${scpm_gz_physics_version_major}.1.0" CACHE STRING "")
endif()
set(scpm_gz_physics_repo "https://github.com/gazebosim/gz-physics")

scpm_install(bullet3)

if (NOT EXISTS ${scpm_work_dir}/gz_physics-${scpm_gz_physics_version_major}-${scpm_gz_physics_version}.installed)
    scpm_download_github_archive("${scpm_gz_physics_repo}" "gz-physics${scpm_gz_physics_version_major}_${scpm_gz_physics_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-physics-gz-physics${scpm_gz_physics_version_major}_${scpm_gz_physics_version}")
    file(WRITE ${scpm_work_dir}/gz_physics-${scpm_gz_physics_version_major}-${scpm_gz_physics_version}.installed)
endif()
set(scpm_gz_physics_lib
    gz_physics
    CACHE STRING ""
)
set(scpm_gz_physics_lib_debug
    gz_physicsd
    CACHE STRING ""
)
set(scpm_gz_physics_depends
    CACHE STRING ""
)
