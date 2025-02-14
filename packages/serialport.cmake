if (NOT scpm_serialport_version)
    set(scpm_serialport_version "libserialport-0.1.2-cmake" CACHE STRING "")
endif()
set(scpm_serialport_repo "https://gitflic.ru/project/paul2la/libserialport.git")

if (NOT EXISTS ${scpm_work_dir}/serialport-${scpm_serialport_version}.installed)
    scpm_clone_git("${scpm_serialport_repo}" "${scpm_serialport_version}")
    scpm_build_cmake("${scpm_work_dir}/libserialport")
    file(WRITE ${scpm_work_dir}/serialport-${scpm_serialport_version}.installed)
endif()

if(scpm_platform_macos)
    set(scpm_serialport_lib ${scpm_serialport_lib}
        serialport
        "-framework IOKit"
        "-framework CoreFoundation"
        CACHE STRING ""
    )
elseif(scpm_platform_ios)
    set(scpm_serialport_lib ${scpm_serialport_lib}
        serialport
        "-framework IOKit"
        "-framework CoreFoundation"
        CACHE STRING ""
    )
else()
    set(scpm_serialport_lib
        serialport
        CACHE STRING ""
    )
endif()
set(scpm_serialport_lib_debug
    serialportd
    CACHE STRING ""
)
set(scpm_serialport_depends
    ""
    CACHE STRING ""
)
