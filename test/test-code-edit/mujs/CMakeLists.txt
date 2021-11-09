cmake_minimum_required(VERSION 2.8) # Проверка версии CMake.
project(mujs)
add_library(mujs one.c)
add_executable(main main.cpp)
target_link_libraries(main mujs)