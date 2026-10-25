cmake_minimum_required(VERSION 3.19)
project(lab6 LANGUAGES C CXX ASM)

set(MCU "atmega328p")
set(F_CPU "16000000UL")

# you gotta set this to be the actual COM port for the Arduino
set(UPLOAD_PORT "COM3")

# Standard Arduino AVR compiler flags
add_compile_options(
    -mmcu=${MCU}
    -DF_CPU=${F_CPU}
    -DARDUINO=10819
    -DARDUINO_AVR_UNO
    -DARDUINO_ARCH_AVR
    -Os
    -Wall
    -ffunction-sections
    -fdata-sections
    $<$<COMPILE_LANGUAGE:CXX>:-std=gnu++11>
    $<$<COMPILE_LANGUAGE:CXX>:-fpermissive>
    $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
    $<$<COMPILE_LANGUAGE:CXX>:-fno-threadsafe-statics>
    $<$<COMPILE_LANGUAGE:C>:-std=gnu11>
    $<$<COMPILE_LANGUAGE:ASM>:-x>
    $<$<COMPILE_LANGUAGE:ASM>:assembler-with-cpp>
)

add_link_options(
    -mmcu=${MCU}
    -Os
    -Wl,--gc-sections
)

# ---------------------------------------------------------
# 1. Arduino Core (OBJECT library preserves ISRs and main())
# ---------------------------------------------------------
file(GLOB ARDUINO_CORE_SRC
    "lib/arduino_core/cores/arduino/*.c"
    "lib/arduino_core/cores/arduino/*.cpp"
    "lib/arduino_core/cores/arduino/*.S"
)

add_library(arduino_core OBJECT ${ARDUINO_CORE_SRC})
target_include_directories(arduino_core PUBLIC
    "lib/arduino_core/cores/arduino"
    "lib/arduino_core/variants/standard"
)
target_compile_options(arduino_core PRIVATE -w)

# ---------------------------------------------------------
# 3. Main Firmware Executable (.elf) and Firmware (.hex)
# ---------------------------------------------------------
add_executable(${PROJECT_NAME}.elf src/main.cpp)
target_link_libraries(${PROJECT_NAME}.elf PRIVATE arduino_core m)

# Automatically convert .elf to .hex and print flash usage on every build
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND "${AVR_OBJCOPY}" -O ihex -R .eeprom $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.hex
    COMMAND "${AVR_SIZE}" -B $<TARGET_FILE:${PROJECT_NAME}.elf>
    COMMENT "Generating ${PROJECT_NAME}.hex and checking memory usage..."
)

# ---------------------------------------------------------
# 4. Flash Target (avrdude)
# ---------------------------------------------------------
add_custom_target(upload
    COMMAND avrdude -p ${MCU} -c arduino -P ${UPLOAD_PORT} -b 115200 -D -U flash:w:${PROJECT_NAME}.hex:i
    DEPENDS ${PROJECT_NAME}.elf
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Flashing ${PROJECT_NAME}.hex to ATmega328P on ${UPLOAD_PORT}..."
)
