if (NOT scpm_png_version)
    set(scpm_png_version "1.6.43" CACHE STRING "")
endif()
if(NOT scpm_platform_android)
    scpm_install(zlib)
endif()
set(scpm_png_repo "https://github.com/glennrp/libpng")

if (NOT EXISTS ${scpm_work_dir}/png-${scpm_png_version}.installed)
    scpm_download_github_archive("${scpm_png_repo}" "v${scpm_png_version}")
    scpm_build_cmake("${scpm_work_dir}/libpng-${scpm_png_version}" "-DPNG_ARM_NEON=off" "-DPNG_TESTS=NO" "-DPNG_ZLIB_VERNUM=0")
    file(WRITE ${scpm_work_dir}/png-${scpm_png_version}.installed)
endif()

if(scpm_platform_windows)
    set(scpm_png_lib
        libpng16_static
        CACHE STRING ""
    )
    set(scpm_png_lib_debug
        libpng16_staticd
        CACHE STRING ""
    )
    set(scpm_png_depends
        zlib
        CACHE STRING ""
    )
else()

    set(scpm_png_lib
        png
        z
        CACHE STRING ""
    )
    set(scpm_png_depends
        ""
        CACHE STRING ""
    )

endif()
