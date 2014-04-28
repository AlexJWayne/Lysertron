// #include "Servo.h"
#include "Joint.h"

const float pi = 3.14159;

Joint FL1;
Joint FL2;
Joint FR1;
Joint FR2;
Joint BR1;
Joint BR2;
Joint BL1;
Joint BL2;

long lastTime = 0;

void setup() {
  Serial.begin(115200);

  FL1.init(2,  15,  1);
  FR1.init(3,  -5, -1);
  BL1.init(4, -10, -1);
  BR1.init(5,  15,  1);
  FL2.init(6,   0,  1);
  FR2.init(7, -15, -1);
  BL2.init(8,   0, -1);
  BR2.init(9, -10,  1);

  delay(1000);
}

void loop() {
  float currentTime = (float)millis() / 1000.0;
  float elapsed = (currentTime - lastTime);

  while (Serial.available() > 0) {
    float serialFloat;
    // segment
    readFloat();

    // tatum
    readFloat();
    
    // beat
    serialFloat = readFloat();
    if (serialFloat > 0) {
      startBeat(serialFloat);
    }

    // bar
    serialFloat = readFloat();
    if (serialFloat > 0) {
      startBar(serialFloat);
    }

    // section
    readFloat();
  }
  
  FL1.update(currentTime);
  FR1.update(currentTime);
  BL1.update(currentTime);
  BR1.update(currentTime);
  FL2.update(currentTime);
  FR2.update(currentTime);
  BL2.update(currentTime);
  BR2.update(currentTime);

  lastTime = currentTime;
}

void startBeat(float duration) {
  // beatDir *= -1;
  // untilBeat = duration;
  // sinceBeat = 0;

  if (FL1.currentAngle > 45) {
    FL1.tween(45+45, duration, Joint::EaseInOut);
  } else {
    FL1.tween(45-45, duration, Joint::EaseInOut);
  }
}

void startBar(float duration) {
  // barDir *= -1;
  // untilBar = duration;
  // sinceBar = 0;
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