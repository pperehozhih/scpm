cmake_minimum_required(VERSION 3.13)
project(demo)
set(VERSION "0.0.1")
set(SHORTVERSION "0")

set(CMAKE_CXX_STANDARD 17)
if (NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/scpm.cmake)
	file(DOWNLOAD https://raw.githubusercontent.com/pperehozhih/scpm/master/scpm.cmake ${CMAKE_CURRENT_BINARY_DIR}/scpm.cmake)
endif()
include(${CMAKE_CURRENT_BINARY_DIR}/scpm.cmake)
set(scpm_server "http://127.0.0.1:8000/")
set(scmp_build_type Debug)
scpm_install(imgui_sdl2)
scpm_install(nfd)
include_directories(SYSTEM "${scpm_root_dir}/include")
include_directories("src")
link_directories("${scpm_root_dir}/lib")
scpm_create_target(TARGET ${PROJECT_NAME} TYPE GUI FILES
    main.cpp
    src/platform.hpp
    src/platform.cpp
)
scpm_link_target(TARGET ${PROJECT_NAME} LIBS imgui_sdl2 nfd)
set_target_properties(${PROJECT_NAME} PROPERTIES SOVERSION ${SHORTVERSION})
if(NOT CYGWIN)
    set_target_properties(${PROJECT_NAME} PROPERTIES VERSION ${VERSION})
endif()
scpm_debugger_setup(${PROJECT_NAME})
