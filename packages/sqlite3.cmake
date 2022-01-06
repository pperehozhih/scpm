if (NOT scpm_sqlite3_version)
	set(scpm_sqlite3_version "3370200" CACHE STRING "")
endif()
set(scpm_sqlite3_repo "https://www.sqlite.org/2022/")

if (NOT EXISTS ${scpm_work_dir}/sqlite3-${scpm_sqlite3_version}.installed)
	scpm_download_and_extract_archive("${scpm_sqlite3_repo}" "sqlite-amalgamation-${scpm_sqlite3_version}.zip")
	# https://www.sqlite.org/2022/sqlite-amalgamation-3370200.zip
	file(DOWNLOAD "${scpm_server}/packages/sqlite3.cmake.in" "${scpm_work_dir}/sqlite-amalgamation-${scpm_sqlite3_version}/CMakeLists.txt")
	scpm_build_cmake("${scpm_work_dir}/sqlite-amalgamation-${scpm_sqlite3_version}")
	file(WRITE ${scpm_work_dir}/sqlite3-${scpm_sqlite3_version}.installed "")
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
