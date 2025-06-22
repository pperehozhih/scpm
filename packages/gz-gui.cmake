if (NOT scpm_gz_gui_version)
    set(scpm_gz_gui_version_major "9" CACHE STRING "")
    set(scpm_gz_gui_version "${scpm_gz_gui_version_major}.0.1" CACHE STRING "")
endif()
set(scpm_gz_gui_repo "https://github.com/gazebosim/gz-gui")

scpm_install(gz-rendering)

if (NOT EXISTS ${scpm_work_dir}/gz_gui-${scpm_gz_gui_version_major}-${scpm_gz_gui_version}.installed)
    scpm_download_github_archive("${scpm_gz_gui_repo}" "gz-gui${scpm_gz_gui_version_major}_${scpm_gz_gui_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-gui-gz-gui${scpm_gz_gui_version_major}_${scpm_gz_gui_version}")
    file(WRITE ${scpm_work_dir}/gz_gui-${scpm_gz_gui_version_major}-${scpm_gz_gui_version}.installed)
endif()
set(scpm_gz_gui_lib
    gz_gui
    CACHE STRING ""
)
set(scpm_gz_gui_lib_debug
    gz_guid
    CACHE STRING ""
)
set(scpm_gz_gui_depends
    CACHE STRING ""
)
