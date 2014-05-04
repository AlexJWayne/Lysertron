#include "DancerThrusts.h"

void DancerThrusts::start() {
  orientation = (random(0, 2) == 0);
  direction = (random(0, 2) == 0 ? 1 : -1);
}

void DancerThrusts::onBeatStart(float duration) {
  direction *= -1;
  float FL1angle = 45 + 15 * direction;
  float FR1angle = 45 + 15 * direction;
  float BL1angle = 30 - 15 * direction;
  float BR1angle = 30 - 15 * direction;

  float FL2angle = 50 + 20 * direction;
  float FR2angle = 50 + 20 * direction;
  float BL2angle = 50 - 20 * direction;
  float BR2angle = 50 - 20 * direction;

  if (orientation) {
    FL1->tween(FL1angle, duration, Joint::EaseOut);
    FR1->tween(FR1angle, duration, Joint::EaseOut);
    BL1->tween(BL1angle, duration, Joint::EaseOut);
    BR1->tween(BR1angle, duration, Joint::EaseOut);

    FL2->tween(FL2angle, duration, Joint::EaseIn);
    FR2->tween(FR2angle, duration, Joint::EaseIn);
    BL2->tween(BL2angle, duration, Joint::EaseIn);
    BR2->tween(BR2angle, duration, Joint::EaseIn);
  } else {
    FL1->tween(BL1angle, duration, Joint::EaseOut);
    FR1->tween(FL1angle, duration, Joint::EaseOut);
    BL1->tween(BR1angle, duration, Joint::EaseOut);
    BR1->tween(FR1angle, duration, Joint::EaseOut);

    FL2->tween(BL2angle, duration, Joint::EaseIn);
    FR2->tween(FL2angle, duration, Joint::EaseIn);
    BL2->tween(BR2angle, duration, Joint::EaseIn);
    BR2->tween(FR2angle, duration, Joint::EaseIn);
  }

}

void DancerThrusts::onBarStart(float duration) {
  // orientation = !orientation;
}