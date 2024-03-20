if (NOT scpm_sqlite3_geo_version)
	set(scpm_sqlite3_geo_version "3.45.2" CACHE STRING "")
endif()
set(scpm_sqlite3_geo_repo "https://gitflic.ru/project/paul2la/sqlite3-with-geo-distance.git")

if (NOT EXISTS ${scpm_work_dir}/sqlite3-geo-${scpm_sqlite3_geo_version}.installed)
	scpm_clone_git("${scpm_png_repo}" "v${scpm_png_version}")
	scpm_build_cmake("${scpm_work_dir}/sqlite3-with-geo-distance")
	file(WRITE ${scpm_work_dir}/sqlite3-geo-${scpm_sqlite3_geo_version}.installed)
endif()

set(scpm_sqlite3_lib
	sqlite3
	CACHE STRING ""
)

set(scpm_sqlite3_lib_debug
	sqlite3d
	CACHE STRING ""
)

set(scpm_sqlite3_depends
	""
	CACHE STRING ""
)
