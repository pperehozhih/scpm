if (NOT scpm_gdal_version)
    set(scpm_gdal_version "3.11.0" CACHE STRING "")
endif()
set(scpm_gdal_repo "https://github.com/OSGeo/GDAL")

scpm_install(proj)

if (NOT EXISTS ${scpm_work_dir}/gdal-${scpm_gdal_version}.installed)
    scpm_download_github_archive("${scpm_gdal_repo}" "v${scpm_gdal_version}")
    scpm_build_cmake("${scpm_work_dir}/gdal-${scpm_gdal_version}" "-DBUILD_PYTHON_BINDINGS=OFF" "-DBUILD_TESTING=OFF" "-DBUILD_CSHARP_BINDINGS=OFF" "-DBUILD_JAVA_BINDINGS=OFF")
    file(WRITE ${scpm_work_dir}/gdal-${scpm_gdal_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_gdal_lib
        gdal
        CACHE STRING ""
    )
    set(scpm_gdal_lib_debug
        gdald
        CACHE STRING ""
    )
else()
    set(scpm_gdal_lib
        z
        CACHE STRING ""
    )
endif()
set(scpm_gdal_depends
    CACHE STRING ""
)
