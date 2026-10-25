cmake_minimum_required(VERSION 3.19)
project(AvrWorkspace LANGUAGES C CXX ASM)

# Include the shared AVR helpers
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/avr.help.cmake)

set(TARGET_PROJ "lab6" CACHE STRING "Select target project")

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${TARGET_PROJ}")
    message(STATUS "[Workspace] Loading ${TARGET_PROJ}...")
    add_subdirectory(${TARGET_PROJ})
else()
    message(FATAL_ERROR "Directory ${TARGET_PROJ} does not exist!")
endif()
