if (NOT scpm_libiio_version)
    set(scpm_libiio_version "0.26" CACHE STRING "")
endif()
set(scpm_libiio_repo "https://github.com/analogdevicesinc/libiio")

scpm_install(libusb)

if (NOT EXISTS ${scpm_work_dir}/libiio-${scpm_libiio_version}.installed)
    scpm_download_github_archive("${scpm_libiio_repo}" "v${scpm_libiio_version}")
    scpm_build_cmake("${scpm_work_dir}/libiio-${scpm_libiio_version}" "-DOSX_FRAMEWORK=OFF")
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
