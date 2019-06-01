if (NOT imgui_version)
	set(imgui_version "1.70" CACHE STRING "")
endif()
set(imgui_repo "https://github.com/ocornut/imgui")

if (NOT EXISTS ${scpm_work_dir}/imgui-${imgui_version}.installed)
    scpm_download_github_archive("${imgui_repo}" "v${imgui_version}")
    file(DOWNLOAD "${scpm_server}/packages/${package_name}.cmake.in" "${scpm_work_dir}/imgui-${imgui_version}/CMakeLists.txt")
	scpm_build_cmake("${scpm_work_dir}/imgui-${imgui_version}" "")
	file(WRITE ${scpm_work_dir}/imgui-${imgui_version}.installed "")
endif()

set(imgui_lib
	imgui
	CACHE STRING ""
)

set(imgui_lib_debug
	imguid
	CACHE STRING ""
)
