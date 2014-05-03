// #include "Servo.h"
#include "Joint.h"
#include "Dancer.h"

#include "Metronome.h"
#include "DancerPushups.h"
#include "DancerHandup.h"

Joint FL1;
Joint FL2;
Joint FR1;
Joint FR2;
Joint BR1;
Joint BR2;
Joint BL1;
Joint BL2;

Metronome metronome;

Dancer *currentDancer;
int currentDancerIndex;

const int dancerCount = 2;
Dancer *dancers[] = {
  new DancerPushups(),
  new DancerHandup()
};

void setup() {
  Serial.begin(115200);

  FL1.init(2,  15,  1);
  FL2.init(3,  -5, -1);
  FR1.init(4, -10, -1);
  FR2.init(5,  15,  1);
  BR1.init(6,   0,  1);
  BR2.init(7, -15, -1);
  BL1.init(8,   0, -1);
  BL2.init(9, -10,  1);

  delay(500);

  dancers[0]->init(FL1, FL2, FR1, FR2, BR1, BR2, BL1, BL2);
  dancers[1]->init(FL1, FL2, FR1, FR2, BR1, BR2, BL1, BL2);

  delay(500);

  currentDancer = dancers[0];

  metronome.start(60);
}

void loop() {
  float currentTime = (float)millis() / 1000.0;

  // while (Serial.available() > 0) {
  //   float duration;
  //   // segment
  //   readFloat();

  //   // tatum
  //   readFloat();
    
  //   // beat
  //   duration = readFloat();
  //   if (duration > 0) {
  //     currentDancer->onBeatStart(duration);
  //   }

  //   // bar
  //   duration = readFloat();
  //   if (duration > 0) {
  //     currentDancer->onBarStart(duration);
  //   }

  //   // section
  //   duration = readFloat();
  //   if (duration > 0) {
  //     currentDancerIndex++;
  //     if (currentDancerIndex >= dancerCount) {
  //       currentDancerIndex = 0;
  //     }
  //     currentDancer = dancers[currentDancerIndex];
  //     Serial.print("currentDancerIndex: ");
  //     Serial.println(currentDancerIndex);
  //   }
  // }
  
  
  metronome.update();

  if (metronome.triggerSection()) {
    currentDancerIndex++;
    if (currentDancerIndex >= dancerCount) {
      currentDancerIndex = 0;
    }
    currentDancer = dancers[currentDancerIndex];
    Serial.print("currentDancerIndex: ");
    Serial.println(currentDancerIndex);
  }

  if (metronome.triggerBeat()) {
    Serial.println("beat ");
    currentDancer->onBeatStart(metronome.spb);
  }

  if (metronome.triggerBar()) {
    Serial.println("bar ");
    currentDancer->onBarStart(metronome.spb * 4.0);
  }


  FL1.update(currentTime);
  FR1.update(currentTime);
  BL1.update(currentTime);
  BR1.update(currentTime);
  FL2.update(currentTime);
  FR2.update(currentTime);
  BL2.update(currentTime);
  BR2.update(currentTime);
}

float readFloat() {
  // Allows us to read bytes as a float
  union {
    char chars[4];
    float floatResult;
  } converter;

  // Buffer that store the bytes
  char buffer[4];

  // Read into the buffer
  Serial.readBytes(buffer, 4);

  // Map the buffer bytes into the converter
  for (int i = 0; i < 4; i++) {
    converter.chars[i] = buffer[i];
  }

  // Snag the result as a float
  return converter.floatResult;
}