#ifndef Metronome_H
#define Metronome_H

#include <Arduino.h>

class Metronome {
  public:
    float bpm;
    float bps;
    float spb;

    int beatsTriggered;
    int barsTriggered;
    int sectionsTriggered;

    int beatsPassed;
    int barsPassed;
    int sectionsPassed;

    void start(float bpm);
    void update();

    bool triggerBeat();
    bool triggerBar();
    bool triggerSection();
};
#endif