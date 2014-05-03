#include "Metronome.h"

void Metronome::start(float _bpm) {
  bpm = _bpm;
  bps = bpm / 60.0;
  spb = 1.0 / bps;
}

void Metronome::update() {
  float time = (float)millis() / 1000;
  beatsPassed    = floor(time * bps);
  barsPassed     = floor(time * bps / 4.0);
  sectionsPassed = floor(time * bps / 16.0);
}

bool Metronome::triggerBeat() {
  if (beatsPassed > beatsTriggered) {
    beatsTriggered = beatsPassed;
    return true;
  }
  return false;
}

bool Metronome::triggerBar() {
  if (barsPassed > barsTriggered) {
    barsTriggered = barsPassed;
    return true;
  }
  return false;
}

bool Metronome::triggerSection() {
  if (sectionsPassed > sectionsTriggered) {
    sectionsTriggered = sectionsPassed;
    return true;
  }
  return false;
}