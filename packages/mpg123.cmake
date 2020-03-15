if (NOT scpm_mpg123_version)
	set(scpm_mpg123_version "1.25.10" CACHE STRING "")
endif()
set(scpm_mpg123_repo "http://downloads.sourceforge.net/project/mpg123/mpg123/")

if (NOT EXISTS ${scpm_work_dir}/mpg123-${scpm_mpg123_version}.installed)
    scpm_download_and_extract_archive("${scpm_mpg123_repo}/${scpm_mpg123_version}/" "mpg123-${scpm_mpg123_version}.tar.bz2")
    # //http://downloads.sourceforge.net/project/mpg123/mpg123/1.25.10/mpg123-1.25.10.tar.bz2
    file(DOWNLOAD "${scpm_server}/packages/mpg123.cmake.in" "${scpm_work_dir}/mpg123-${scpm_mpg123_version}/CMakeLists.txt")
    file(DOWNLOAD "${scpm_server}/packages/mpg123.config.in" "${scpm_work_dir}/mpg123-${scpm_mpg123_version}/config.h.in")
    file(DOWNLOAD "${scpm_server}/packages/mpg123.mpg123.in" "${scpm_work_dir}/mpg123-${scpm_mpg123_version}/mpg123.h.in")
	scpm_build_cmake("${scpm_work_dir}/mpg123-${scpm_mpg123_version}")
	file(WRITE ${scpm_work_dir}/mpg123-${scpm_mpg123_version}.installed "")
endif()

set(scpm_mpg123_lib
	mpg123
	CACHE STRING ""
)

set(scpm_mpg123_lib_debug
	mpg123d
	CACHE STRING ""
)

set(scpm_mpg123_depends
	""
	CACHE STRING ""
)
