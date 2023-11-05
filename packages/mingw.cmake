if (NOT scpm_mingw_version)
	set(scpm_mingw_version "0.6.3" CACHE STRING "")
endif()
if (NOT EXISTS "${scpm_work_dir}/root/mingw.${scpm_mingw_version}.installed")
	file(DOWNLOAD "http://osdn.net/dl/mingw/mingw-get-${scpm_mingw_version}-mingw32-pre-20170905-1-bin.zip" "${scpm_work_dir}/root/mingw-${scpm_mingw_version}.zip")
	execute_process(
		COMMAND ${CMAKE_COMMAND} -E tar xzf ${scpm_work_dir}/root/mingw-${scpm_mingw_version}.zip
		WORKING_DIRECTORY ${scpm_work_dir}/root
	)
	find_program (MINGW_EXEC NAMES "mingw-get.exe" HINTS "${scpm_work_dir}/root/bin/")
	execute_process(
		COMMAND ${MINGW_EXEC} install msys
		WORKING_DIRECTORY ${scpm_work_dir}/root
	)
	execute_process(
		COMMAND ${MINGW_EXEC} install msys-perl
		WORKING_DIRECTORY ${scpm_work_dir}/root
	)
	file(WRITE ${scpm_work_dir}/mingw-${scpm_mingw_version}.installed "")
endif()
find_program (scpm_bash_exec NAMES "bash.exe" HINTS "${scpm_work_dir}/root/msys/1.0/bin/")
find_program (scpm_make_exec NAMES "make.exe" HINTS "${scpm_work_dir}/root/msys/1.0/bin/")
find_program (scpm_sh_exec NAMES "sh.exe" HINTS "${scpm_work_dir}/root/msys/1.0/bin/")
find_program (scpm_perl_exec NAMES "perl.exe" HINTS "${scpm_work_dir}/root/msys/1.0/bin/")
get_filename_component(MSVC_COMPILER_DIRECTORY ${CMAKE_C_COMPILER} DIRECTORY)
file(TO_NATIVE_PATH ${MSVC_COMPILER_DIRECTORY} MSVC_COMPILER_DIRECTORY)
set(ENV{PATH} "$ENV{PATH}${MSVC_COMPILER_DIRECTORY};")
get_filename_component(MSVC_INCLUDE_DIRECTORY ${MSVC_COMPILER_DIRECTORY}/../../../include ABSOLUTE)
get_filename_component(MSVC_BIN_DIRECTORY ${MSVC_COMPILER_DIRECTORY}/../../../bin ABSOLUTE)
get_filename_component(MSVC_LIB_DIRECTORY ${MSVC_COMPILER_DIRECTORY}/../../../Lib/x86 ABSOLUTE)
file(TO_NATIVE_PATH ${MSVC_INCLUDE_DIRECTORY} MSVC_INCLUDE_DIRECTORY)
file(TO_NATIVE_PATH ${MSVC_LIB_DIRECTORY} MSVC_LIB_DIRECTORY)
file(TO_NATIVE_PATH ${MSVC_BIN_DIRECTORY} MSVC_BIN_DIRECTORY)
get_filename_component(MS_SDK_INSTALL "[HKEY_LOCAL_MACHINE\\SOFTWARE\\WOW6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v10.0;InstallationFolder]"
					   ABSOLUTE CACHE)
get_filename_component(MS_SDK_VERSION "[HKEY_LOCAL_MACHINE\\SOFTWARE\\WOW6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v10.0;ProductVersion]"
					   NAME CACHE)
set(ENV{PATH} "$ENV{PATH}${scpm_work_dir}/root/msys/1.0/bin/;")
set(ENV{INCLUDE} "${MS_SDK_INSTALL}/include/${MS_SDK_VERSION}.0/um/;${MS_SDK_INSTALL}/include/${MS_SDK_VERSION}.0/shared/;${MSVC_INCLUDE_DIRECTORY};${MS_SDK_INSTALL}/include/${MS_SDK_VERSION}.0/ucrt/")
set(ENV{LIB} "${MS_SDK_INSTALL}/Lib/${MS_SDK_VERSION}.0/um/x86/;${MSVC_LIB_DIRECTORY};${MS_SDK_INSTALL}/Lib/${MS_SDK_VERSION}.0/ucrt/x86/")
set(ENV{CC} ${CMAKE_C_COMPILER})