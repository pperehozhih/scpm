if (NOT scpm_freerdp_version)
    set(scpm_freerdp_version "2.7.0" CACHE STRING "")
endif()
scpm_install(openssl)
scpm_install(openh264)
set(scpm_freerdp_repo "https://github.com/FreeRDP/FreeRDP")

if (NOT EXISTS ${scpm_work_dir}/freerdp-${scpm_freerdp_version}.installed)
    scpm_download_github_archive("${scpm_freerdp_repo}" "${scpm_freerdp_version}")
    scpm_build_cmake("${scpm_work_dir}/freerdp-${scpm_freerdp_version}")
    file(RENAME ${scpm_root_dir}/include/freerdp2/freerdp ${scpm_root_dir}/include/freerdp)
    file(REMOVE ${scpm_root_dir}/include/freerdp2)
    file(RENAME ${scpm_root_dir}/include/winpr2/winpr ${scpm_root_dir}/include/winpr)
    file(REMOVE ${scpm_root_dir}/include/winpr2)
    file(WRITE ${scpm_work_dir}/freerdp-${scpm_freerdp_version}.installed)
endif()

set(scpm_freerdp_lib
    freerdp2
    freerdp-client2
    winpr-tools2
    winpr2
    CACHE STRING ""
)
set(scpm_freerdp_lib_debug
    freerdp2d
    freerdp-client2d
    winpr-tools2d
    winpr2
    CACHE STRING ""
)
set(scpm_freerdp_depends
    openssl
    openh264
    CACHE STRING ""
)
