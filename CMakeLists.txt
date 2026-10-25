cmake_minimum_required(VERSION 3.19)

set(TARGET_LAB "lab6" CACHE STRING "Select target lab")

project(LabWorkspace LANGUAGES C CXX ASM)

if(TARGET_LAB STREQUAL "lab6")
    message(STATUS "[Workspace] this is lab6...")
    add_subdirectory(lab6)
elseif(TARGET_LAB STREQUAL "lab7")
    message(STATUS "[Workspace] this is lab7...")
    add_subdirectory(lab7)
else()
    message(FATAL_ERROR "Unknown TARGET_LAB: ${TARGET_LAB}")
endif()
