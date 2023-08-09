cmake_minimum_required(VERSION 3.18)
project(clang-hook)

add_subdirectory(hook)
add_subdirectory(test)

set_property(DIRECTORY PROPERTY VS_STARTUP_PROJECT test)