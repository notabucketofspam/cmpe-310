project(lab7 LANGUAGES C CXX ASM)

import_core_library(Wire "atmega328p" "standard" "ARDUINO_AVR_UNO")
import_arduino_library(LiquidCrystal_I2C "atmega328p" "standard" "ARDUINO_AVR_UNO")
target_link_libraries(LiquidCrystal_I2C PUBLIC Wire)

# TARGET_NAME, MCU, ARDUINO_VARIANT, ARDUINO_MACRO, PROGRAMMER
add_avr_firmware(${PROJECT_NAME} "atmega328p" "standard" "ARDUINO_AVR_UNO" "arduino"
  src/main.cpp
)

target_link_libraries(${PROJECT_NAME}.elf PRIVATE Wire LiquidCrystal_I2C)
