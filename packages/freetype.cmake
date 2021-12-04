if (NOT scpm_freetype_version)
    set(scpm_freetype_version "VER-2-10-4" CACHE STRING "")
endif()
scpm_install(png)
scpm_install(bzip2)
scpm_install(zlib)
scpm_install(harfbuzz)
scpm_install(brotli)
set(scpm_freetype_repo "https://github.com/freetype/freetype.git")

if (NOT EXISTS ${scpm_work_dir}/freetype-${scpm_freetype_version}.installed)
    if(EXISTS "${scpm_work_dir}/freetype-${scpm_freetype_version}")
        file(REMOVE_RECURSE "${scpm_work_dir}/freetype-${scpm_freetype_version}")
    endif()
    execute_process(
        COMMAND git clone -b ${scpm_freetype_version} --depth 1 ${scpm_freetype_repo} freetype-${scpm_freetype_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_freetype_clone_reult
    )
    if (NOT scpm_freetype_clone_reult EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_freetype_repo}")
    endif()
    scpm_build_cmake("${scpm_work_dir}/freetype-${scpm_freetype_version}" "")
    if (EXISTS "${scpm_root_dir}/lib/libfreetyped.a")
        file(RENAME "${scpm_root_dir}/lib/libfreetyped.a" "${scpm_root_dir}/lib/libfreetype.a")
    endif()
    file(RENAME ${scpm_root_dir}/include/freetype2/freetype ${scpm_root_dir}/include/freetype)
    file(RENAME ${scpm_root_dir}/include/freetype2/ft2build.h ${scpm_root_dir}/include/ft2build.h)
    file(REMOVE ${scpm_root_dir}/include/freetype2)
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
    brotli
    CACHE STRING ""
)
