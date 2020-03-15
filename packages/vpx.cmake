if (NOT scpm_vpx_version)
    set(scpm_vpx_version "1.8.0" CACHE STRING "")
endif()
scpm_install(yuv)
set(scpm_vpx_repo "https://github.com/webmproject/libvpx")

if (NOT EXISTS ${scpm_work_dir}/libvpx-${scpm_vpx_version}.installed)
    scpm_download_github_archive("${scpm_vpx_repo}" "v${scpm_vpx_version}")
    file(DOWNLOAD "${scpm_server}/packages/vpx.cmake.in" "${scpm_work_dir}/libvpx-${scpm_vpx_version}/CMakeLists.txt")
    file(DOWNLOAD "${scpm_server}/packages/vpx.vpx_config.h.in" "${scpm_work_dir}/libvpx-${scpm_vpx_version}/vpx_config.h")
    file(DOWNLOAD "${scpm_server}/packages/vpx.vpx_config.c.in" "${scpm_work_dir}/libvpx-${scpm_vpx_version}/vpx_config.c")
    file(DOWNLOAD "${scpm_server}/packages/vpx.vpx_scale_rtcd.h.in" "${scpm_work_dir}/libvpx-${scpm_vpx_version}/vpx_scale_rtcd.h")
    file(DOWNLOAD "${scpm_server}/packages/vpx.vpx_dsp_rtcd.h.in" "${scpm_work_dir}/libvpx-${scpm_vpx_version}/vpx_dsp_rtcd.h")
    file(DOWNLOAD "${scpm_server}/packages/vpx.vp8_rtcd.h.in" "${scpm_work_dir}/libvpx-${scpm_vpx_version}/vp8_rtcd.h")
    file(DOWNLOAD "${scpm_server}/packages/vpx.vp9_rtcd.h.in" "${scpm_work_dir}/libvpx-${scpm_vpx_version}/vp9_rtcd.h")
    file(DOWNLOAD "${scpm_server}/packages/vpx.vpx_version.h.in" "${scpm_work_dir}/libvpx-${scpm_vpx_version}/vpx_version.h")
    scpm_build_cmake("${scpm_work_dir}/libvpx-${scpm_vpx_version}")
    file(WRITE ${scpm_work_dir}/libvpx-${scpm_vpx_version}.installed)
endif()

set(scpm_vpx_lib
    vpx
    CACHE STRING ""
)
set(scpm_vpx_lib_debug
    vpxd
    CACHE STRING ""
)
set(scpm_vpx_depends
    yuv
    CACHE STRING ""
)
