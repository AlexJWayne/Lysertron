const int pinLedGreen = 10;
const int pinLedRed   = 11;

const int EVT_SEGMENT  = 1;
const int EVT_TATUM    = 2;
const int EVT_BEAT     = 3;
const int EVT_BAR      = 4;
const int EVT_SECTION  = 5;

const float dimTime = 0.15; // seconds it takes for the led to fade.

float lightValueGreen = 0.0;
float lightValueRed   = 0.0;

long lastLoop = 0;

void setup() {
  Serial.begin(9600);
  pinMode(pinLedGreen, OUTPUT);
  pinMode(pinLedRed,   OUTPUT);
}

void loop() {
  float thisLoop = millis();
  float decreaseAmount = (float)(thisLoop - lastLoop) / (dimTime * 1000.0);

  lightValueRed -= decreaseAmount;
  if (lightValueRed < 0) lightValueRed = 0;

  lightValueGreen -= decreaseAmount;
  if (lightValueGreen < 0) lightValueGreen = 0;

  while (Serial.available() > 0) {
    int serialVal = Serial.read();
    Serial.print(serialVal);

    if (serialVal == EVT_BEAT) lightValueGreen = 1.0;
    if (serialVal == EVT_BAR)  lightValueRed = 1.0;
  }

  analogWrite(pinLedGreen, 255 * lightValueGreen);
  analogWrite(pinLedRed,   255 * lightValueRed);

  lastLoop = thisLoop;
}

