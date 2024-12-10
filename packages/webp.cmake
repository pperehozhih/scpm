if (NOT scpm_webp_version)
    set(scpm_webp_version "1.3.2" CACHE STRING "")
endif()
set(scpm_webp_repo "https://github.com/webmproject/libwebp")

if (NOT EXISTS ${scpm_work_dir}/webp-${scpm_webp_version}.installed)
    scpm_download_github_archive("${scpm_webp_repo}" "v${scpm_webp_version}")
    scpm_build_cmake("${scpm_work_dir}/libwebp-${scpm_webp_version}" "-DWEBP_BUILD_ANIM_UTILS=OFF" "-DWEBP_BUILD_CWEBP=OFF" "-DWEBP_BUILD_DWEBP=OFF" "-DWEBP_BUILD_GIF2WEBP=OFF" "-DWEBP_BUILD_IMG2WEBP=OFF" "-DWEBP_BUILD_VWEBP=OFF" "-DWEBP_BUILD_WEBPINFO=OFF" "-DWEBP_BUILD_WEBPMUX=OFF" "-DWEBP_BUILD_EXTRAS=OFF" "-DWEBP_LINK_STATIC=ON")
    file(WRITE ${scpm_work_dir}/webp-${scpm_webp_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_webp_lib
        sharpyuv
        webp
        webpdecoder
        webpdemux
        webpmux    
        CACHE STRING ""
    )
    set(scpm_webp_lib_debug
        sharpyuvd
        webpd
        webpdecoderd
        webpdemuxd
        webpmuxd
        CACHE STRING ""
    )
else()
    set(scpm_webp_lib
        sharpyuv
        webp
        webpdecoder
        webpdemux
        webpmux
        CACHE STRING ""
    )
endif()
set(scpm_webp_depends
    ""
    CACHE STRING ""
)
