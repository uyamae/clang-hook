cmake_minimum_required(VERSION 3.18)
set(CMAKE_CXX_STANDARD 17)
project(clang-hook)

add_subdirectory(hook)
add_subdirectory(test)
add_dependencies(test clang-hook)
set_property(DIRECTORY PROPERTY VS_STARTUP_PROJECT test)