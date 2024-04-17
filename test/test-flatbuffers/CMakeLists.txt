cmake_minimum_required(VERSION 3.13)
project(test)
set(CMAKE_CXX_STANDARD 17)
if (NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/scpm.cmake)
	file(DOWNLOAD https://raw.githubusercontent.com/pperehozhih/scpm/master/scpm.cmake ${CMAKE_CURRENT_BINARY_DIR}/scpm.cmake)
endif()
include(${CMAKE_CURRENT_BINARY_DIR}/scpm.cmake)
set(scpm_server "http://127.0.0.1:8000/")
scpm_install(flatbuffers)
include_directories("${scpm_root_dir}/include")
include_directories("${CMAKE_CURRENT_BINARY_DIR}/generated")
link_directories("${scpm_root_dir}/lib")

find_package(flatbuffers REQUIRED)
set(FB_SCHEMA
    "fbs/test.fbs")
build_flatbuffers("${FB_SCHEMA}" "" fbschemas "" "${CMAKE_CURRENT_BINARY_DIR}/generated" "" "")

add_executable(${PROJECT_NAME} main.cpp)

scpm_link_target(TARGET ${PROJECT_NAME} LIBS flatbuffers )

add_dependencies(${PROJECT_NAME} fbschemas)
