#include <FastLED.h>

#define DATA_PIN   11 // SPI MOSI pin
#define CLOCK_PIN  13 //13 //SPI  SCK

#define COLOR_ORDER BGR  // most of the 10mm black APA102
// #define COLOR_ORDER GBR //mike's short teset strip, 19 pixels

#define CHIPSET     APA102
#define NUM_LEDS    600

#define FPS 20

//CRGB leds[NUM_LEDS];
CRGBArray<NUM_LEDS> leds;

CRGBPalette16 currentPalette;
TBlendType    currentBlending;

int brightness = 30;


uint8_t values[NUM_LEDS];

void setup() {
  delay(3000); // sanity delay

  FastLED.addLeds<CHIPSET, DATA_PIN, CLOCK_PIN, COLOR_ORDER, DATA_RATE_MHZ(8)>(leds, NUM_LEDS).setCorrection( TypicalSMD5050 );
  //FastLED.addLeds<CHIPSET, COLOR_ORDER>(leds, NUM_LEDS).setCorrection( TypicalSMD5050 );
  FastLED.setBrightness( brightness );

  currentPalette = LavaColors_p;
  // currentPalette = OceanColors_p;
  // currentPalette = ForestColors_p;

  currentBlending = LINEARBLEND;
}

void loop()
{
  brightness = analogRead(0) / 4;
  FastLED.setBrightness( brightness );


  static uint8_t startpix = 0;
  startpix++;
//  if (startpix>NUM_LEDS) startpix=0;

  FillLEDsFromPaletteColors( startpix);

  FastLED.show();
  FastLED.delay(1000/FPS);

}


void FillLEDsFromPaletteColors( uint8_t colorIndex)
{
  uint8_t brightness = 255;
  
  for( int i = 0; i < NUM_LEDS; i++) {
    leds[i] = ColorFromPalette( currentPalette, colorIndex, brightness, currentBlending);
    colorIndex += 1;
  }
}


// This example shows how to set up a static color palette
// which is stored in PROGMEM (flash), which is almost always more
// plentiful than RAM.  A static PROGMEM palette like this
// takes up 64 bytes of flash.

/*
possible water colors
CRGB::Aqua 0x00FFFF (cyan)
CRGB::Aquamarine 0x7FFFD4
CRGB::CadetBlue 0x5F9eA0
CRGB::CornflowerBlue 6495ED
CRGB::DeepSkyBlue 0x00BFFF
CRGB::DarkSlateGray 0x2F4F4F
CRGB::DimGray 0x696969
CRGB::DodgerBlue 0x1E90FF
CRGB::LightSkyBlue 0x87CEFA
CRGB::MediumBlue 0x0000CD
CRGB::MidnightBlue 0x191970
CRGB::Navy 0x000080
CRGB::RoyalBlue 0x4169E1
CRGB::SeaGreen 0x2E8B57
CRGB::SkyBlue 0x87CEEB
CRGB::SteelBlue 0x4682B4

*/
/*const TProgmemRGBPalette16 LavaColors_p FL_PROGMEM =
{
    CRGB::Black,
    CRGB::Maroon,
    CRGB::Black,
    CRGB::Maroon,

    CRGB::DarkRed,
    CRGB::Maroon,
    CRGB::DarkRed,

    CRGB::DarkRed,
    CRGB::DarkRed,
    CRGB::Red,
    CRGB::Orange,

    CRGB::White,
    CRGB::Orange,
    CRGB::Red,
    CRGB::DarkRed
};
*/
const TProgmemRGBPalette16 WaterColors_p FL_PROGMEM =
{
    CRGB::MidnightBlue,
    CRGB::DarkBlue,
    CRGB::MidnightBlue,
    CRGB::Navy,

    CRGB::DarkBlue,
    CRGB::MediumBlue,
    CRGB::SeaGreen,
    CRGB::Teal,

    CRGB::CadetBlue,
    CRGB::Blue,
    CRGB::DarkCyan,
    CRGB::CornflowerBlue,

    CRGB::Aquamarine,
    CRGB::SeaGreen,
    CRGB::Aqua,
    CRGB::LightSkyBlue
};
