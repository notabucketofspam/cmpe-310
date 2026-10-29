#undef __INT24_MAX__
#include <Arduino.h>
#include <avr/io.h>
#include <stdlib.h>
#include <string.h>
#include <util/delay.h>

#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

void setup() {
  lcd.init();
  lcd.backlight();
}

void loop(){
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(String(analogRead(A0)*5.0/(1UL<<10)) + "V");
  _delay_ms(100);
}
