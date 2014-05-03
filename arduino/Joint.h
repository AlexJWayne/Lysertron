#ifndef Joint_H
#define Joint_H

#define PI 3.14159265359;

#include "Servo.h"
#include <Arduino.h>


class Joint {
  public:
    enum Easing {
      EaseLinear,
      EaseInOut,
      EaseIn,
      EaseOut,
      EaseInOutLoop,
    };

    // Joint();
    void init(int pin, float offset, float direction, float initialAngle);

    int pin;
    float offset;
    float direction;
    float currentAngle;
    Servo servo;

    // tweening
    float tweenStartTime;
    float tweenEndTime;
    float tweenStartAngle;
    float tweenEndAngle;
    Easing tweenEasing;

    void tween(float angle, float duration);
    void tween(float angle, float duration, Easing easing);
    float tweenCompletion();

    void update(float currentTime);
    void move(float angle);

  private:
    float currentTime;

};
#endif