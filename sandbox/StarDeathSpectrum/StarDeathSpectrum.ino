#include <FastLED.h>

#define DATA_PIN   9 // SPI MOSI pin
#define CLOCK_PIN  8 //13 //SPI  SCK
#define THUMBPOT_PIN 0 // analog in

#define COLOR_ORDER BGR  // most of the 10mm black APA102
// #define COLOR_ORDER GBR //mike's short teset strip, 19 pixels

#define CHIPSET     APA102
#define NUM_LEDS    600

#define BRIGHTPOT  // comment this out if there is no analog control of brightness

#define FPS 30

CRGBArray<NUM_LEDS> leds;

CRGBPalette16 currentPalette;
TBlendType    currentBlending;
uint8_t values[NUM_LEDS];


//*********************************************************************
// define globals

unsigned long int SEQ_PERIOD = 1 * 60 * 1000;   // full sequence duration, in milliseconds
#define FLASH_DUR  4 * 1000         // duration of the flash, rise and fall, in ms
#define FLASHRISE_DUR 1 * 1000     // duration of the flash rise time
#define GROWSEQ_DUR SEQ_PERIOD - FLASH_DUR //duration of main growth sequence
#define NSTATE 3                      // the number of states

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

///*
// * update the global brightness based on the analog pot
// */
//void updateBright() {
//  #ifdef BRIGHTPOT
//    brightness = map(analogRead(THUMBPOT_PIN), 0, 1023, 0, 255);
//  #else
//    brightness = 255;
//  #endif
//  FastLED.setBrightness( gBrightness );
//}

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

/*
 * check to see where we are in a full time cycle
 * and restarts the loop clock if we are past SEQ_PERIOD
 */
bool restartLoopCheck(float curTime) {
  if ( millis()-startTime > SEQ_PERIOD) {
    startTime = millis();
    Serial.print("restarting after ");
    Serial.print(str((millis()-startTime)/1000));
    Serial.print(" sec\n");
    return true;
  }
  return false;
}

int lerp(int x1, int x2, float t) {
  return x1 + (x2 - x1) * t;
}

float lerpf(float x1, float x2, float t) {
  return x1 + (x2 - x1) * t;
}

CRGB lerpColor(CRGB color1, CRGB color2, float interval) {
  // THIS CONVERSION STILL SUCKS! FIX IT!
  return color1 + (color2 - color1) * int(interval*255);
}


void fillLEDsFromPaletteColors( uint8_t colorIndex)
{
  uint8_t brightness = 255;
  for( int i = 0; i < NUM_LEDS; i++) {
    leds[i] = ColorFromPalette( currentPalette, colorIndex, brightness, currentBlending);
    colorIndex += 1;
  }
}


//*********************************************************************
// primary methods

void setup() {
  Serial.begin(9600);
  delay(3000); // sanity delay

  FastLED.addLeds<CHIPSET, DATA_PIN, CLOCK_PIN, COLOR_ORDER, DATA_RATE_MHZ(8)>(leds, NUM_LEDS).setCorrection( TypicalSMD5050 );
  FastLED.setBrightness( gBrightness );

  startTime = millis();
  phaseStartTime = millis();
  state = 0;
  progress = 0;
}

/*
 * THE MAIN LOOP
 */
void loop() {
//  updateBright();

  float progress = updateProgress();
  CRGB curColor = getCurrentColor(state, progress);
  fill_solid(leds, NUM_LEDS, curColor);
  
  FastLED.show();
  FastLED.delay(1000/FPS);

}

