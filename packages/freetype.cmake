if (NOT scpm_freetype_version)
    set(scpm_freetype_version "2.10.0" CACHE STRING "")
endif()
scpm_install(png)
scpm_install(bzip2)
scpm_install(zlib)
scpm_install(harfbuzz)
set(scpm_freetype_repo "https://download.savannah.gnu.org/releases/freetype")

if (NOT EXISTS ${scpm_work_dir}/freetype-${scpm_freetype_version}.installed)
    scpm_download_and_extract_archive("${scpm_freetype_repo}" "freetype-${scpm_freetype_version}.tar.bz2")
    scpm_build_cmake("${scpm_work_dir}/freetype-${scpm_freetype_version}" "")
    file(WRITE ${scpm_work_dir}/freetype-${scpm_freetype_version}.installed)
endif()

if(EMSCRIPTEN)
    set(FREETYPE_INCLUDE_DIRS "${scpm_root_dir}/include/freetype2" CACHE STRING "")
    set(FREETYPE_LIBRARY "${scpm_root_dir}/lib/freetype.a" CACHE STRING "")
endif(EMSCRIPTEN)

set(scpm_freetype_lib
    freetype
    CACHE STRING ""
)
set(scpm_freetype_lib_debug
    freetyped
    CACHE STRING ""
)
set(scpm_freetype_depends
    png
    bzip2
    harfbuzz
    CACHE STRING ""
)
