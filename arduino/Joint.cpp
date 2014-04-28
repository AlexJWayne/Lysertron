#include "Joint.h"

Joint::Joint() {}

void Joint::init(int _pin, float _offset, float _direction) {
  pin = _pin;
  offset = _offset;
  direction = _direction;
  currentTime = 0.1;
  servo.attach(pin);
  tween(0, 0, EaseLinear);
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
  }

  return completion;
}

void Joint::update(float _currentTime) {
  currentTime = _currentTime;
  float diff = tweenEndAngle - tweenStartAngle;
  move(tweenStartAngle + diff * tweenCompletion());
}

void Joint::move(float angle) {
  currentAngle = angle;
  servo.write(90 + offset + (currentAngle * direction));
}