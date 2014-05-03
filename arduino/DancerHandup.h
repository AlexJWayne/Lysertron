#ifndef DancerHandup_H
#define DancerHandup_H
#include "Dancer.h"

class DancerHandup : public Dancer {
  public:
    Joint *back1;
    Joint *back2;
    Joint *sideLong1;
    Joint *sideLong2;
    Joint *sideShort1;
    Joint *sideShort2;
    Joint *hand1;
    Joint *hand2;

    bool bounceUp;
    bool handUp;
    bool handRight;
    int beatCount;
    int barCount;

    void start();
    void onBeatStart(float duration);
    void onBarStart(float duration);

  private:
    bool didSetup;
    void setup();
};

#endif