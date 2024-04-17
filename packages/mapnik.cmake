if (NOT scpm_mapnik_version)
    set(scpm_mapnik_version "master" CACHE STRING "")
endif()
set(scpm_mapnik_repo "https://github.com/mapnik/mapnik")

scpm_install(zlib)
scpm_install(icu)
scpm_install(boost)
scpm_install(harfbuzz)

if (NOT EXISTS ${scpm_work_dir}/mapnik-${scpm_mapnik_version}.installed)
    scpm_clone_git("${scpm_mapnik_repo}" "${scpm_mapnik_version}")
    scpm_build_cmake("${scpm_work_dir}/mapnik")
    file(WRITE ${scpm_work_dir}/mapnik-${scpm_mapnik_version}.installed)
endif()

set(scpm_mapnik_lib
    mapnik
    CACHE STRING ""
)
set(scpm_mapnik_lib_debug
    mapnikd
    CACHE STRING ""
)
set(scpm_mapnik_depends
    harfbuzz
    boost
    icu
    z
    CACHE STRING ""
)
