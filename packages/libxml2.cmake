if (NOT scpm_llibxml2_version)
    set(scpm_libxml2_version "2.11.9-1" CACHE STRING "")
endif()
set(scpm_libxml2_repo "https://github.com/winlibs/libxml2")

if(scpm_platform_windows)
    scpm_install(zlib)
endif()

if (NOT EXISTS ${scpm_work_dir}/libxml2-${scpm_libxml2_version}.installed)
    scpm_download_github_archive("${scpm_libxml2_repo}" "libxml2-${scpm_libxml2_version}")
    scpm_build_cmake("${scpm_work_dir}/libxml2-libxml2-${scpm_libxml2_version}" "-DLIBXML2_WITH_PROGRAMS=OFF" "-DLIBXML2_WITH_PYTHON=OFF" "-DLIBXML2_WITH_TESTS=OFF" "-DLIBXML2_WITH_ICONV=OFF" "-DLIBXML2_WITH_ICU=OFF" "-DLIBXML2_WITH_LZMA=OFF" "-DLIBXML2_WITH_THREADS=OFF")
    file(WRITE ${scpm_work_dir}/libxml2-${scpm_libxml2_version}.installed "")
endif()

set(scpm_libxml2_lib
    libxml2
    CACHE STRING ""
)
set(scpm_libxml2_lib_debug
    libxml2d
    CACHE STRING ""
)
set(scpm_libxml2_depends
    ""
    CACHE STRING ""
)
