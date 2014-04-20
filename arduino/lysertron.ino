#include "Servo.h"

Servo barServo;

struct Joint {
  int pin;
  float offset;
  float dir;
  Servo servo;
};

Joint FL1 = { 2,  15,  1 };
Joint FL2 = { 3,  -5, -1 };
Joint FR1 = { 4, -10, -1 };
Joint FR2 = { 5,  15,  1 };
Joint BR1 = { 6,   0,  1 };
Joint BR2 = { 7, -15, -1 };
Joint BL1 = { 8,   0, -1 };
Joint BL2 = { 9, -10,  1 };

const int EVT_SEGMENT  = 1;  // 00000001
const int EVT_TATUM    = 2;  // 00000010
const int EVT_BEAT     = 4;  // 00000100
const int EVT_BAR      = 8;  // 00001000
const int EVT_SECTION  = 16; // 00010000

long lastLoop = 0;

float sinceBeat;
float untilBeat;

float sinceBar;
float untilBar;

float beatDir = 1;
float barDir  = 1;

void setup() {
  Serial.begin(9600);
  
  jointInit(FL1);
  jointInit(FL2);
  jointInit(FR1);
  jointInit(FR2);
  jointInit(BR1);
  jointInit(BR2);
  jointInit(BL1);
  jointInit(BL2);
}

void loop() {
  float thisLoop = millis();
  float elapsed = (thisLoop - lastLoop) / 1000;
  

  sinceBeat += elapsed;
  untilBeat -= elapsed;
  if (untilBeat < 0) untilBeat = 0;

  sinceBar += elapsed;
  untilBar -= elapsed;
  if (untilBar < 0) untilBar = 0;

  while (Serial.available() > 0) {
    // float serialFloat;

    // // first value is beat
    // serialFloat = Serial.parseFloat();
    // if (serialFloat > 0) {
    //   // startBeat(serialFloat);
    //   jointMove(FL2, random(-10, 10));
    // }

    // // second is bar
    // serialFloat = Serial.parseFloat();
    // if (serialFloat > 0) {
    //   // untilBar = serialFloat;
    // }

    int serialVal = Serial.read();

    // Check presence of event bits with a binary and operation.
    if (serialVal & EVT_BEAT)  {
      startBeat(0.2);
    }

    if (serialVal & EVT_BAR) {
      untilBar = 0.2;
      sinceBar = 0;
      barDir *= -1;
    }
  }

  float completion = sinceBeat / (sinceBeat + untilBeat);
  jointMove(FL2, 60 - 5 * completion * beatDir);
  jointMove(FR2, 60 - 5 * completion * beatDir);
  jointMove(BL2, 60 - 5 * completion * beatDir);
  jointMove(BR2, 60 - 5 * completion * beatDir);  
  
  completion = sinceBar / (sinceBar + untilBar);
  jointMove(FL1, 30 - 10 * completion * barDir);
  jointMove(FR1, 30 - 10 * completion * barDir);
  jointMove(BL1, 30 - 10 * completion * barDir);
  jointMove(BR1, 30 - 10 * completion * barDir);
  
  lastLoop = thisLoop;
}

void startBeat(float duration) {
  beatDir *= -1;
  untilBeat = duration;
  sinceBeat = 0;
}

void jointInit(Joint joint) {
  joint.servo.attach(joint.pin);
  jointMove(joint, 0);
}

void jointMove(Joint joint, float angle) {
  joint.servo.write(
    90 + joint.offset + (
      angle * joint.dir
    )
  );
}