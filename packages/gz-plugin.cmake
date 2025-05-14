if (NOT scpm_gz_plugin_version)
    set(scpm_gz_plugin_version_major "3" CACHE STRING "")
    set(scpm_gz_plugin_version "${scpm_gz_plugin_version_major}.0.1" CACHE STRING "")
endif()
set(scpm_gz_plugin_repo "https://github.com/gazebosim/gz-plugin")

# scpm_install(eigen)
scpm_install(gz-utils)

if (NOT EXISTS ${scpm_work_dir}/gz_plugin-${scpm_gz_plugin_version_major}-${scpm_gz_plugin_version}.installed)
    scpm_download_github_archive("${scpm_gz_plugin_repo}" "gz-plugin${scpm_gz_plugin_version_major}_${scpm_gz_plugin_version}")
    scpm_build_cmake("${scpm_work_dir}/gz-plugin-gz-plugin${scpm_gz_plugin_version_major}_${scpm_gz_plugin_version}")
    file(WRITE ${scpm_work_dir}/gz_plugin-${scpm_gz_plugin_version_major}-${scpm_gz_plugin_version}.installed)
endif()
set(scpm_gz_plugin_lib
    gz_plugin
    CACHE STRING ""
)
set(scpm_gz_plugin_lib_debug
    gz_plugind
    CACHE STRING ""
)
set(scpm_gz_plugin_depends
    gz-utils
    CACHE STRING ""
)
