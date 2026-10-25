cmake_minimum_required(VERSION 3.19)
project(LabWorkspace LANGUAGES C CXX ASM)

# Include the shared AVR helpers
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/avr.help.cmake)

set(TARGET_LAB "lab6" CACHE STRING "Select target lab")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${TARGET_LAB}")
    message(STATUS "[Workspace] Loading ${TARGET_LAB}...")
    add_subdirectory(${TARGET_LAB})
else()
    message(FATAL_ERROR "Directory ${TARGET_LAB} does not exist!")
endif()
