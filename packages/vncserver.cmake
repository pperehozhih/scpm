if (NOT scpm_zlib_version)
    set(scpm_zlib_version "1.3.1" CACHE STRING "")
endif()
set(scpm_zlib_repo "https://github.com/LibVNC/libvncserver")

if (NOT EXISTS ${scpm_work_dir}/libvncserver-${scpm_libvncserver_version}.installed)
    scpm_download_github_archive("${scpm_libvncserver_repo}" "v${scpm_libvncserver_version}")
    scpm_build_cmake("${scpm_work_dir}/libvncserver-${scpm_libvncserver_version}")
    file(WRITE ${scpm_work_dir}/libvncserver-${scpm_libvncserver_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_libvncserver_lib
        libvncserver
        CACHE STRING ""
    )
    set(scpm_libvncserver_lib_debug
        zlibd
        CACHE STRING ""
    )
else()
    set(scpm_libvncserver_lib
        libvncserver
        CACHE STRING ""
    )
endif()
set(scpm_libvncserver_depends
    CACHE STRING ""
)
