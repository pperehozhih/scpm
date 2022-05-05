if (NOT scpm_openh264_version)
	set(scpm_openh264_version "2.2.0" CACHE STRING "")
endif()
set(scpm_openh264_repo "https://github.com/cisco/openh264")

if (NOT EXISTS ${scpm_work_dir}/openh264-${scpm_openh264_version}.installed)
    scpm_download_and_extract_archive("${scpm_openh264_repo}/archive/refs/tags" "v${scpm_openh264_version}.tar.gz")
    if (scpm_platform_windows)
        scpm_install(mingw)
    else()
        find_program (scpm_make_exec NAMES "make")
        find_program (scpm_perl_exec NAMES "perl")
    endif()
    execute_process(
        COMMAND ${scpm_make_exec} install DESTDIR=${scpm_root_dir} PREFIX=""
        WORKING_DIRECTORY "${scpm_work_dir}/openh264-${scpm_openh264_version}"
        RESULT_VARIABLE scpm_openhh264_make_result
    )
    file(WRITE ${scpm_work_dir}/openh264-${scpm_openh264_version}.installed)
endif()

set(scpm_openh264_lib
    openh264
	CACHE STRING ""
)

set(scpm_openh264_lib_debug
    openh264d
	CACHE STRING ""
)

set(scpm_openh264_depends
	""
	CACHE STRING ""
)