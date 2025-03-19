cmake_minimum_required(VERSION 3.13)
project(testiio)
set(CMAKE_CXX_STANDARD 17)
if (NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/scpm.cmake)
	file(DOWNLOAD https://raw.githubusercontent.com/pperehozhih/scpm/master/scpm.cmake ${CMAKE_CURRENT_BINARY_DIR}/scpm.cmake)
endif()
include(${CMAKE_CURRENT_BINARY_DIR}/scpm.cmake)
set(scpm_server "http://127.0.0.1:8000/")
#set(scpm_boost_version "1.87.0" CACHE STRING "")
#set(scmp_build_type Debug)
# scpm_install(boost)
#scpm_install(openal_soft)
scpm_install(libxml2)
scpm_install(libiio)
#scpm_install(soapysdr)
#scpm_install(sndfile)
# scpm_install(fftw3)
#scpm_install(gnuradio)
#scpm_install(samplerate)
# scpm_install(liquid)
# scpm_install(python)
#scpm_install(soapyhackrf)
include_directories("${scpm_root_dir}/include")
link_directories("${scpm_root_dir}/lib")
if (scpm_platform_android)
	add_library( libiio SHARED IMPORTED )
    set_target_properties(libiio PROPERTIES IMPORTED_LOCATION ${scpm_root_dir}/lib/libiio.so)
    add_library( libxml2 SHARED IMPORTED )
    set_target_properties(libxml2 PROPERTIES IMPORTED_LOCATION ${scpm_root_dir}/lib/libxml2.so)
	scpm_create_target(TARGET ${PROJECT_NAME} TYPE SHARED FILES
		main.cpp pluto_iio.c pluto_iio.h
    )
	target_link_libraries(${PROJECT_NAME}
		libxml2
		libiio
        usb-1.0
        android
        EGL
        GLESv3
        log)
else()
	scpm_create_target(TARGET ${PROJECT_NAME} TYPE CONSOLE FILES
		main.cpp pluto_iio.c pluto_iio.h
	)
	scpm_link_target(TARGET ${PROJECT_NAME} LIBS libiio libusb)
endif()

