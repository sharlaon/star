/*
 * A tool to figure out what colors look best on the LEDs
 * MJP 2016.10.01
 */
#include <FastLED.h>

#define DATA_PIN   9 // SPI MOSI pin
#define CLOCK_PIN  8 //13 //SPI  SCK
#define THUMBPOT_PIN A0 // analog in
#define CHIPSET     APA102

#define COLOR_ORDER BGR  // most of the 10mm black APA102

#define NUM_LEDS    300

#define FPS 120

CRGB leds[NUM_LEDS];

//*********************************************************************
// define globals

unsigned long long SEQ_PERIOD = 60LL * 1000LL;   // full sequence duration, in milliseconds
unsigned long int FLASH_DUR = 4 * 1000;         // duration of the flash, rise and fall, in ms
unsigned long int FLASHRISE_DUR = 1 * 1000;     // duration of the flash rise time
unsigned long int GROWSEQ_DUR = SEQ_PERIOD - FLASH_DUR; //duration of main growth sequence
int NSTATE = 3;                      // the number of states

unsigned long int startTime;      // absolute start time of sequence loop
unsigned long int phaseStartTime;  // absolute time since start of lastPhase

int state;
uint8_t gBrightness = 255;
float progress;

//*********************************************************************
// control methods


/*
 * update the progress
 */
float updateProgress() {
  float progress = 0;
  long int elapsedTime = millis() - phaseStartTime;
  switch(state) {
    case 0: {
      progress = elapsedTime / GROWSEQ_DUR;
      break;
    }
    case 1: {
      progress = elapsedTime / FLASHRISE_DUR;
      break;
    }
    case 2: {
      progress = elapsedTime / (FLASH_DUR - FLASHRISE_DUR);
      break;
    }
  }
  
  // update the state if we are finished
  if (progress >= 1.0) {
    progress = 0;
    phaseStartTime = millis();
    state = state+1 % NSTATE;
    if (state==0)
      startTime = millis();
  }
  return progress;
}


/*
 * given the current state and progress [0, 1), return the color and set the global brightness
 */
CRGB getCurrentColor(int state, float progress) {
  CRGB newColor = CRGB(0,0,0);
  float radius = 0; //where the hell am i putting this?
  switch(state) {
    case 0: {
      CHSV startColorGrow = CHSV(210, int(0.25 * 255), int(0.5 * 255));
      CHSV middleColorGrow = CHSV(60, int(0.5 * 255),  int(0.5 * 255));
      CHSV endColorGrow = CHSV(0, 255, int(0.5 * 255));
      if (progress < 0.75) {
        newColor = lerpColor(startColorGrow, middleColorGrow, progress / 0.75);
        radius = lerpf(0.1, 0.4, progress / 0.75);
      }
      else {
        newColor = lerpColor(middleColorGrow, endColorGrow, (progress - 0.75) / 0.25);
        radius = lerpf(0.4, 1.0, (progress - 0.75) / 0.25);
      }
      break;
    }
    case 1: {
      CHSV startColorFlashUp = CHSV(0, 255, int(0.5 * 255));
      CHSV endColorFlashUp = CHSV(0, 255, 255);
      newColor = lerpColor(startColorFlashUp, endColorFlashUp, progress);
      //do an easing on the brightness increase?
      radius = 0; // ? why we setting this to zero here?
      break;
    }
    case 2: {
      CHSV startColorFlashDown = CHSV(0, 255, int(0.5 * 255));
      CHSV endColorFlashDown = CHSV(0, 255, 255);
      newColor = lerpColor(startColorFlashDown, endColorFlashDown, progress);
      radius = 0;
      break;
    }
  }
  return newColor;
}

int lerp(int x1, int x2, float t) {
  return x1 + (x2 - x1) * t;
}

float lerpf(float x1, float x2, float t) {
  return x1 + (x2 - x1) * t;
}

CRGB lerpColor(CRGB color1, CRGB color2, float interval) {
  // THIS CONVERSION IS BORKED! FIX IT!
//  return color1 + (color2 - color1) * int(interval*255);
  CRGB newColor = CRGB(0, 0, 0);
  for(int i=0; i<3; i++)
    newColor[i] = color1[i] + (color2[i] - color1[i]) * int(interval * 255);
}

//*********************************************************************
// primary methods

void setup() {
  Serial.begin(9600);
  delay(1000); // sanity delay

  FastLED.addLeds<CHIPSET, DATA_PIN, CLOCK_PIN, COLOR_ORDER, DATA_RATE_MHZ(8)>(leds, NUM_LEDS).setCorrection( TypicalSMD5050 );
  FastLED.setBrightness( 255 );

  startTime = millis();
  phaseStartTime = millis();
  state = 0;
  progress = 0;

}

/*
 * THE MAIN LOOP
 */
void loop() {
  fill_solid(leds, NUM_LEDS, CHSV(int(0.2 * 255), int(0.8 * 255), 255));

  float progress = updateProgress();

  // test for hue/saturation levels
  uint16_t v = analogRead(THUMBPOT_PIN);
  int thumbVal = map(v, 0, 1023, 0, 255);
  fill_solid(leds, NUM_LEDS, CHSV(thumbVal, 255, 255));

  FastLED.show();
  FastLED.delay(1000/FPS);
}
