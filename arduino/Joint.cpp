#include "Joint.h"

const int SERVOMIN = 160;
const int SERVOMAX = 590;

void Joint::init(Adafruit_PWMServoDriver& _pwmDriver, int _pin, float _offset, float _direction, float initialAngle) {
  pwmDriver = &_pwmDriver;

  pin = _pin;
  offset = _offset;
  direction = _direction;
  currentTime = 0.1;
  servo.attach(pin);

  currentAngle = initialAngle;
  move(currentAngle);
}

void Joint::tween(float angle, float duration) {
  tween(angle, duration, EaseInOut);
}

void Joint::tween(float angle, float duration, Easing easing) {
  tweenStartTime  = currentTime;
  tweenEndTime    = currentTime + duration;
  tweenStartAngle = currentAngle;
  tweenEndAngle   = angle;
  tweenEasing     = easing;
}

float Joint::tweenCompletion() {
  float completion = (currentTime - tweenStartTime) / (tweenEndTime - tweenStartTime);
  if (completion < 0) { return 0; }
  if (completion > 1) { return 1; }

  switch(tweenEasing) {
    case EaseInOut:
      completion = 0.5 - cos(completion * PI) * 0.5;
      break;

    case EaseOut:
      completion = 1.0 - cos(completion * PI * 0.5);
      break;

    case EaseIn:
      completion = sin(completion * PI * 0.5);
      break;

    case EaseInOutLoop:
      completion = 0.5 - cos(completion * PI * 2) * 0.5;
      break;
  }

  return completion;
}

void Joint::update(float _currentTime) {
  currentTime = _currentTime;
  float diff = tweenEndAngle - tweenStartAngle;
  if (abs(diff) > 0.0) {
    move(tweenStartAngle + diff * tweenCompletion());
  }
}

void Joint::move(float angle) {
  currentAngle = angle;
  
  float absAngle = 90 + offset + currentAngle * direction;
  float pulseLen = map(absAngle, 0, 180, SERVOMIN, SERVOMAX);
  pwmDriver->setPWM(pin, 0, pulseLen);
}