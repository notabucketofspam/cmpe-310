#include <Arduino.h>
#include <avr/io.h>
#include <stdlib.h>
#include <string.h>

void setup() {
	pinMode(13, OUTPUT);
	pinMode(12, OUTPUT);
}
unsigned long long ftime = 0;
unsigned char theSenate = 0;
void loop() {
	if (millis() - ftime > 666) {
		ftime = millis();
			++theSenate;
		digitalWrite(13, theSenate&1);
		digitalWrite(12, (theSenate >> 1) & 1);
	}
}
