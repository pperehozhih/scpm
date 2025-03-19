if (NOT scpm_libusb_version)
    set(scpm_libusb_version "1.0.27-1" CACHE STRING "")
endif()
set(scpm_libusb_repo "https://github.com/libusb/libusb-cmake")

if (NOT EXISTS ${scpm_work_dir}/libusb-${scpm_libusb_version}.installed)
    scpm_download_github_archive("${scpm_libusb_repo}" "v${scpm_libusb_version}")
    scpm_build_cmake("${scpm_work_dir}/libusb-cmake-${scpm_libusb_version}")
    file(WRITE ${scpm_work_dir}/libusb-${scpm_libusb_version}.installed "")
endif()

set(scpm_libusb_lib
    usb-1.0
    CACHE STRING ""
)
set(scpm_libusb_lib_debug
    usb-1.0d
    CACHE STRING ""
)
set(scpm_libusb_depends
    ""
    CACHE STRING ""
)
