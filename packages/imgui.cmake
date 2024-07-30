if (NOT scpm_imgui_version)
	set(scpm_imgui_version "1.91.0" CACHE STRING "")
endif()
set(scpm_imgui_repo "https://github.com/ocornut/imgui")

if (NOT EXISTS ${scpm_work_dir}/imgui-${scpm_imgui_version}.installed)
    scpm_download_github_archive("${scpm_imgui_repo}" "v${scpm_imgui_version}")
    file(DOWNLOAD "${scpm_server}/packages/${package_name}.cmake.in" "${scpm_work_dir}/imgui-${scpm_imgui_version}/CMakeLists.txt")
	scpm_build_cmake("${scpm_work_dir}/imgui-${scpm_imgui_version}" "-DCMAKE_CXX_FLAGS='-I${scpm_root_dir}/include -I${scpm_root_dir}/include/freetype2' -DImTextureID uint32_t")
	file(WRITE ${scpm_work_dir}/imgui-${scpm_imgui_version}.installed "")
endif()

set(scpm_imgui_lib
	imgui
	CACHE STRING ""
)

set(scpm_imgui_lib_debug
	imguid
	CACHE STRING ""
)

set(scpm_imgui_depends
	""
	CACHE STRING ""
)
