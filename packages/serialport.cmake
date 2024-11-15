if (NOT scpm_serialport_version)
    set(scpm_serialport_version "libserialport-0.1.2-cmake" CACHE STRING "")
endif()
set(scpm_bzip2_repo "https://gitflic.ru/project/paul2la/libserialport.git")

if (NOT EXISTS ${scpm_work_dir}/serialport-${scpm_serialport_version}.installed)
    scpm_clone_git("${scpm_serialport_repo}" "${scpm_serialport_version}")
    scpm_build_cmake("${scpm_work_dir}/serialport")
    file(WRITE ${scpm_work_dir}/serialport-${scpm_serialport_version}.installed)
endif()

set(scpm_serialport_lib
    serialport
    CACHE STRING ""
)
set(scpm_serialport_lib_debug
    serialportd
    CACHE STRING ""
)
set(scpm_serialport_depends
    ""
    CACHE STRING ""
)
