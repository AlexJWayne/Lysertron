#include "DancerHandup.h"

void DancerHandup::start() {
  bounceUp  = false;
  handUp    = false;
  handRight = true;
  beatCount = 0;
  barCount  = 0;

  switch (rand() % 4) {
    case 0:
      hand1 = FL1; break;
    case 1:
      hand1 = FR1; break;
    case 2:
      hand1 = BL1; break;
    case 3:
      hand1 = BR1; break;
  }

  setup();
}

void DancerHandup::onBeatStart(float duration) {
  beatCount++;
  bounceUp = !bounceUp;

  float dir = bounceUp ? 1 : 0;

  back2->tween(      5 +  5 * dir, duration);
  sideLong2->tween( 55 + 10 * dir, duration);
  sideShort2->tween(55 + 10 * dir, duration);

  back1->tween(     45, duration);
  sideLong1->tween( 55, duration);
  sideShort1->tween(35, duration);

  float angle;
  if (beatCount % 2 == 0) {
    handRight = !handRight;
    angle = handRight ? -10 : 60;
    hand1->tween(angle, duration * 2.0);
  } else {
    handUp = !handUp;
    angle = handUp ? -80 : 0;
    hand2->tween(angle, duration * 2.0, handUp ? Joint::EaseIn : Joint::EaseOut);
  }
}

// void DancerHandup::onBarStart(float duration) {
//   barCount++;

//   if (barCount % 4 == 0) {
//     setup();
//   }
// }

void DancerHandup::setup() {
  if (hand1 == BL1) {
    back1       = BR1;
    back2       = BR2;
    sideLong1   = BL1;
    sideLong2   = BL2;
    sideShort1  = FR1;
    sideShort2  = FR2;
    hand1       = FL1;
    hand2       = FL2;
  } else if (hand1 == FL1) {
    back1 = BL1;
    back2 = BL2;
    sideLong1 = BR1;
    sideLong2 = BR2;
    sideShort1 = FL1;
    sideShort2 = FL2;
    hand1 = FR1;
    hand2 = FR2;
  } else if (hand1 == FR1) {
    back1 = FL1;
    back2 = FL2;
    sideLong1 = FR1;
    sideLong2 = FR2;
    sideShort1 = BL1;
    sideShort2 = BL2;
    hand1 = BR1;
    hand2 = BR2;
  } else {
    back1 = FR1;
    back2 = FR2;
    sideLong1 = FL1;
    sideLong2 = FL2;
    sideShort1 = BR1;
    sideShort2 = BR2;
    hand1 = BL1;
    hand2 = BL2;
  }
}