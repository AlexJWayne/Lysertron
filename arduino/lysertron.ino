#include "Servo.h"

Servo barServo;

const int pinServo    = 9;
const int pinLedGreen = 5;
const int pinLedRed   = 6;

const int EVT_SEGMENT  = 1;  // 00000001
const int EVT_TATUM    = 2;  // 00000010
const int EVT_BEAT     = 4;  // 00000100
const int EVT_BAR      = 8;  // 00001000
const int EVT_SECTION  = 16; // 00010000

const float dimTime = 0.25; // seconds it takes for the led to fade.

float lightValueGreen = 1.0;
float lightValueRed   = 1.0;

long lastLoop = 0;

bool beatServoOn = false;
bool barServoOn  = false;

void setup() {
  Serial.begin(9600);
  pinMode(pinLedGreen, OUTPUT);
  pinMode(pinLedRed,   OUTPUT);
  barServo.attach(pinServo);
}

void loop() {
  float thisLoop = millis();
  float decreaseAmount = (float)(thisLoop - lastLoop) / (dimTime * 1000.0);

  lightValueRed = lightValueRed - decreaseAmount;
  if (lightValueRed < 0.0) lightValueRed = 0.0;

  lightValueGreen = lightValueGreen - decreaseAmount;
  if (lightValueGreen < 0.0) lightValueGreen = 0.0;

  while (Serial.available() > 0) {
    int serialVal = Serial.read();

    // Check presence of event bits with a binary and operation.
    if (serialVal & EVT_BEAT)  {
      lightValueGreen = 1.0;
      beatServoOn = !beatServoOn;
    }

    if (serialVal & EVT_BAR) {
      lightValueRed = 1.0;
      barServoOn = !barServoOn;
      beatServoOn = barServoOn;
    }

  }

  analogWrite(pinLedGreen, 255 * lightValueGreen);
  analogWrite(pinLedRed,   255 * lightValueRed);

  int barAngle  = barServoOn ? 55 : 125;
  int beatAngle = beatServoOn ? -10 : 10;
  barServo.write(barAngle + beatAngle);

  lastLoop = thisLoop;
}

