#undef __INT24_MAX__
#include <Arduino.h>
#include <avr/io.h>
#include <stdlib.h>
#include <string.h>
#include <util/delay.h>

#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

void task_1(void);
void task_2(void);

void setup() {
  lcd.init();
  lcd.backlight();
  pinMode(13, OUTPUT);
  pinMode(12, INPUT_PULLUP);
}

void loop(){
  task_1();
  task_2();
  _delay_ms(1000);
}

void task_2() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(String((analogRead(A0) * 5.0 - analogRead(A1) * 5.0) / (1UL << 10)) + "V");
}

void task_1() {
  unsigned isnt_continuous = digitalRead(12);
  digitalWrite(13, !isnt_continuous);
}
