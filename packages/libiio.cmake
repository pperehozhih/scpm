if (NOT scpm_libiio_version)
    set(scpm_libiio_version "0.26" CACHE STRING "")
endif()
set(scpm_libiio_repo "https://github.com/analogdevicesinc/libiio")

scpm_install(libusb)
if(scpm_platform_windows)
    scpm_install(libxml2)
endif()

if (NOT EXISTS ${scpm_work_dir}/libiio-${scpm_libiio_version}.installed)
    scpm_download_github_archive("${scpm_libiio_repo}" "v${scpm_libiio_version}")
    if(scpm_platform_windows)
        scpm_build_cmake("${scpm_work_dir}/libiio-${scpm_libiio_version}" "-DOSX_FRAMEWORK=OFF" "-DLIBUSB_LIBRARIES=${scpm_root_dir}/lib/usb-1.0.lib" "-DLIBUSB_INCLUDE_DIR=${scpm_root_dir}/include/libusb-1.0" "-DWITH_TESTS=OFF")
    else()
        scpm_build_cmake("${scpm_work_dir}/libiio-${scpm_libiio_version}" "-DOSX_FRAMEWORK=OFF" "-DLIBUSB_LIBRARIES=${scpm_root_dir}/lib/libusb-1.0.a" "-DLIBUSB_INCLUDE_DIR=${scpm_root_dir}/include/libusb-1.0" "-DWITH_TESTS=OFF" "-DHAVE_DNS_SD=OFF")
    endif()
    file(WRITE ${scpm_work_dir}/libiio-${scpm_libiio_version}.installed "")
endif()

set(scpm_libiio_lib
    iio
    CACHE STRING ""
)
set(scpm_libiio_lib_debug
    iiod
    CACHE STRING ""
)
set(scpm_libiio_depends
    libusb
    CACHE STRING ""
)
