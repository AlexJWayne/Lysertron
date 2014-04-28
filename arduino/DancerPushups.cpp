#include "DancerPushups.h"

DancerPushups::DancerPushups() {
  direction = 1;
}

void DancerPushups::onBeatStart(float duration) {
  direction *= -1;

  FL1->tween(45 + 25 * direction, duration);
  FR1->tween(45 - 25 * direction, duration);
  BL1->tween(45 - 25 * direction, duration);
  BR1->tween(45 + 25 * direction, duration);
}

void DancerPushups::onBarStart(float duration) {
  float angle;
  if (FL2->currentAngle > 45) {
    angle = 30;
  } else {
    angle = 60;
  }

  FL2->tween(angle, duration);
  FR2->tween(angle, duration);
  BL2->tween(angle, duration);
  BR2->tween(angle, duration);
}