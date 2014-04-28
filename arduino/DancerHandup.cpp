#include "DancerHandup.h"

void DancerHandup::onBeatStart(float duration) {
  if (!didSetup) {
    didSetup = true;
    setup();
  }

  beatCount++;
  if (beatCount > 1) beatCount = 0;
  bounceUp = !bounceUp;

  float dir = bounceUp ? 1 : 0;

  back2->tween(      5 +  5 * dir, duration, Joint::EaseInOut);
  sideLong2->tween( 55 + 10 * dir, duration, Joint::EaseInOut);
  sideShort2->tween(55 + 10 * dir, duration, Joint::EaseInOut);

  back1->tween(     45, duration, Joint::EaseInOut);
  sideLong1->tween( 55, duration, Joint::EaseInOut);
  sideShort1->tween(35, duration, Joint::EaseInOut);

  float angle;
  switch(beatCount) {
    case 0:
      handRight = !handRight;
      angle = handRight ? 10 : 60;
      hand1->tween(angle, duration);
      break;

    case 1:
      handUp = !handUp;
      angle = handUp ? -60 : -15;
      hand2->tween(angle, duration);
      break;
  }
}

void DancerHandup::onBarStart(float duration) {
  setup();
}

void DancerHandup::setup() {
  // if (hand1 == BL1) {
    back1       = BR1;
    back2       = BR2;
    sideLong1   = BL1;
    sideLong2   = BL2;
    sideShort1  = FR1;
    sideShort2  = FR2;
    hand1       = FL1;
    hand2       = FL2;
  // } else if (hand1 == FL1) {
  //   back1 = BL1;
  //   back2 = BL2;
  //   sideLong1 = BR1;
  //   sideLong2 = BR2;
  //   sideShort1 = FL1;
  //   sideShort2 = FL2;
  //   hand1 = FR1;
  //   hand2 = FR2;
  // } else if (hand1 == FR1) {
  //   back1 = FL1;
  //   back2 = FL2;
  //   sideLong1 = FR1;
  //   sideLong2 = FR2;
  //   sideShort1 = BL1;
  //   sideShort2 = BL2;
  //   hand1 = BR1;
  //   hand2 = BR2;
  // } else {
  //   back1 = FR1;
  //   back2 = FR2;
  //   sideLong1 = FL1;
  //   sideLong2 = FL2;
  //   sideShort1 = BR1;
  //   sideShort2 = BR2;
  //   hand1 = BL1;
  //   hand2 = BL2;
  // }
}