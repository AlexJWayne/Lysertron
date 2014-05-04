#ifndef DancerThrusts_H
#define DancerThrusts_H
#include "Dancer.h"

class DancerThrusts : public Dancer {
  public:
    float direction;
    bool orientation;

    void start();
    void onBeatStart(float duration);
    void onBarStart(float duration);
};

#endif