#include "Dancer.h"

void Dancer::init(
  Joint& _FL1,
  Joint& _FL2,
  Joint& _FR1,
  Joint& _FR2,
  Joint& _BR1,
  Joint& _BR2,
  Joint& _BL1,
  Joint& _BL2
) {
  FL1 = &_FL1;
  FL2 = &_FL2;
  FR1 = &_FR1;
  FR2 = &_FR2;
  BR1 = &_BR1;
  BR2 = &_BR2;
  BL1 = &_BL1;
  BL2 = &_BL2;
}