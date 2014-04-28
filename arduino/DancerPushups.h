#ifndef DancerPushups_H
#define DancerPushups_H
#include "Dancer.h"

class DancerPushups : public Dancer {
  public:
    DancerPushups();
    float direction;

    void onBeatStart(float duration);
    void onBarStart(float duration);
};

#endif