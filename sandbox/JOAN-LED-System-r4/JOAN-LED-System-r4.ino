/*

  LED driver system for J.O.A.N
As shipped to brooklyn in May of 2016



dependencies: https://github.com/jgillick/arduino-LEDFader
download zip here: https://github.com/jgillick/arduino-LEDFader/archive/master.zip
in Ardurino, go to [Sketch>Include Library> Add .ZIP Library and select the zip above.

     $$$$$\     $$$$$$\       $$$$$$\      $$\   $$\
     \__$$ |   $$  __$$\     $$  __$$\     $$$\  $$ |
        $$ |   $$ /  $$ |    $$ /  $$ |    $$$$\ $$ |
        $$ |   $$ |  $$ |    $$$$$$$$ |    $$ $$\$$ |
  $$\   $$ |   $$ |  $$ |    $$  __$$ |    $$ \$$$$ |
  $$ |  $$ |   $$ |  $$ |    $$ |  $$ |    $$ |\$$$ |
  \$$$$$$  |$$\ $$$$$$  |$$\ $$ |  $$ |$$\ $$ | \$$ |$$\
   \______/ \__|\______/ \__|\__|  \__|\__|\__|  \__|\__|

Contact Robb Godshaw 818.408.9343 robb@robb.cc www.robb.cc

\\\\\SWITCHES + LED indicators\\\\\
~On/off whole system (day/night)
    ~LED indicates power on arduino
~Breathe/steady whole system
    ~LED will mirror white LEDS
~White/ code blue 
    ~LED will mirror blue LEDS
(All transitions are smooth, regardless of switch use)
\\\\\SLIDERS\\\\\

The secret knob on the back controls max brightness for blue AND white

~Slider 1 adjusts max brightness of white
~Slider 2 Adjusts max brightness of blue
~Slider 3 adjusts breath rate
(the sliders adjust max brightness of each color, both in steady and in breathe.
*/


#include <LEDFader.h>

//These are the pin assignements. Use to rewire.
#define WHITE_LED_PIN 9//10
#define BLUE_LED_PIN 10//11

#define DEFAULT_LED_PIN 13

#define WHITE_MOSFET_PIN 5 //these go to GATE on the high-power mosfet transistors.
#define BLUE_MOSFET_PIN 6

//No more sliders
// #define MAX_BRIGHTNESS_KNOB_PIN A0 //these are the slider knobs.
// #define BLUE_SLIDER_PIN A1
// #define FADE_SPEED_SLIDER_PIN A2

// #define MAX_BRIGHTNESS_KNOB_PIN A1

#define MIN_BRIGHTNESS 44//how low can we go? 255 is 100 and 0 is zero

#define POWER_SWITCH_PIN 2 
#define BREATHE_STEADY_SWITCH_PIN 3
#define WHITE_BLUE_SWITCH_PIN 4

// #define WHITE_BLUE_GLOBAL_FADE_TIME 2000
#define GLOBAL_FADE_TIME 555
#define GLOBAL_FAST_FADE_TIME 4


/*
Breathe Slowly

Normal breathing is somewhere between 12 and 16 breaths per minute
hyperventilation can be 25 or even 40 breaths per minute
When doing deep breathing- 2 or 3 breaths per minute.
Your first goal is to slow your breathing down to somewhere between 6 and 10 breaths per minute.
*/



int fadeDuration = 40; //this is the variable fade duration in milliseconds between sine values

boolean breathe = false;
boolean on = false;
boolean blue = false;


LEDFader whiteLed;
LEDFader blueLed;

int globalMax = 255;//overwritten soon. 

//this stuff is to make the breathing pretty and natural.
const byte adaSine[] = {1, 1, 2, 3, 5, 8, 11, 15, 20, 25, 30, 36, 43, 49, 56, 64, 72, 80, 88, 97, 105, 114, 123, 132, 141, 150, 158, 167, 175, 183, 191, 199, 206, 212, 219, 225, 230, 235, 240, 244, 247, 250, 252, 253, 254, 255, 254, 253, 252, 250, 247, 244, 240, 235, 230, 225, 219, 212, 206, 199, 191, 183, 175, 167, 158, 150, 141, 132, 123, 114, 105, 97, 88, 80, 72, 64, 56, 49, 43, 36, 30, 25, 20, 15, 11, 8, 5, 3, 2, 1, 0};
const byte lenAdaSine = 91;//how long is sine array?
byte sineIndex = 0;//where are we in sine wave? at begining!
//Sine wave from Adafruits open src breathing iCufflinks https://www.adafruit.com/icufflinks

// the setup function runs once when you press reset or power the board
void setup() {
  // Serial.begin(9600);


//---------------------------------------------- Set PWM frequency for D9 & D10 ------------------------------
 
TCCR1B = TCCR1B & B11111000 | B00000001;    // set timer 1 divisor to     1 for PWM frequency of 31372.55 Hz
// TCCR1B = TCCR1B & B11111000 | B00000010;    // set timer 1 divisor to     8 for PWM frequency of  3921.16 Hz
// TCCR1B = TCCR1B & B11111000 | B00000011;    // set timer 1 divisor to    64 for PWM frequency of   490.20 Hz (The DEFAULT)
//TCCR1B = TCCR1B & B11111000 | B00000100;    // set timer 1 divisor to   256 for PWM frequency of   122.55 Hz
//TCCR1B = TCCR1B & B11111000 | B00000101;    // set timer 1 divisor to  1024 for PWM frequency of    30.64 Hz

  pinMode(POWER_SWITCH_PIN, INPUT_PULLUP);  //init pins as inputs with resisitors
  pinMode(BREATHE_STEADY_SWITCH_PIN, INPUT_PULLUP);  //init pins as inputs with resisitors
  pinMode(WHITE_BLUE_SWITCH_PIN, INPUT_PULLUP);  //init pins as inputs with resisitors

  pinMode(WHITE_LED_PIN,OUTPUT);    //Initialize pins to be outputs
  pinMode(BLUE_LED_PIN,OUTPUT);    //Initialize pins to be outputs
  pinMode(DEFAULT_LED_PIN,OUTPUT);    //Initialize pins to be outputs
  pinMode(WHITE_MOSFET_PIN,OUTPUT);    //Initialize pins to be outputs
  pinMode(BLUE_MOSFET_PIN,OUTPUT);    //Initialize pins to be outputs


  whiteLed = LEDFader(WHITE_LED_PIN);
  whiteLed.fade(0, GLOBAL_FADE_TIME);
  // whiteLed.set_curve(exponential)

  blueLed = LEDFader(BLUE_LED_PIN);
  blueLed.fade(0, GLOBAL_FADE_TIME);
  // blueLed.set_curve(exponential)

  // led.set_curve("exponential")
}

void loop() {
  //this is called about 200 times a second
  delay(3);//????this makes things smooth as eggs
  updateMode();
  blueLed.update();
  whiteLed.update();
  if(on){
      digitalWrite(DEFAULT_LED_PIN, HIGH); //this is the power indicator. It is on when the ardurino is

  if (whiteLed.is_fading() == false && blueLed.is_fading() == false){
    //if it has reached its goal, take time to next one
    if(!breathe){//if we are in steady mode...
      if(blue){//blue mode
        blueLed.fade(globalMax, GLOBAL_FAST_FADE_TIME);
        whiteLed.fade(0,GLOBAL_FADE_TIME); 
      }
      if(!blue){//white mode
        whiteLed.fade(globalMax, GLOBAL_FAST_FADE_TIME);
        blueLed.fade(0,GLOBAL_FADE_TIME);
      }
    }
    if(breathe){
      breatheRoutine();
    }
  }
}
else{
  if (whiteLed.is_fading() == false && blueLed.is_fading() == false){
        whiteLed.fade(0,GLOBAL_FADE_TIME); 
        blueLed.fade(0,GLOBAL_FADE_TIME);
        digitalWrite(DEFAULT_LED_PIN, LOW); //this is the power indicator. It is on when the ardurino is
}


}
}

void breatheRoutine(){
  //this is called when LEDs should be breathing.
  // int breathPeriod = 1/(BREATHS_PER_MINUTE * 60 * 1000);//desired duration of wave
  // fadeDuration = breathPeriod/lenAdaSine ;


  if(sineIndex==lenAdaSine-1){sineIndex=0;}//if we are at the end of the sine wave, go to the start
  if(blue){//blue mode
    int scaledBlueGoal = constrain(map(adaSine[sineIndex],0,255,MIN_BRIGHTNESS,globalMax),MIN_BRIGHTNESS,globalMax);
    blueLed.fade(scaledBlueGoal, fadeDuration);
    // blueLed.fade(adaSine[sineIndex], fadeDuration);
    whiteLed.fade(0,GLOBAL_FADE_TIME); 
  }
  if(!blue){//white mode
    int scaledWhiteGoal = constrain(map(adaSine[sineIndex],0,255,MIN_BRIGHTNESS,globalMax),MIN_BRIGHTNESS,globalMax);

    // whiteLed.fade(adaSine[sineIndex], fadeDuration);
    whiteLed.fade(scaledWhiteGoal, fadeDuration);
    blueLed.fade(0,GLOBAL_FADE_TIME); 
  }
  sineIndex++;//Add 1 to sine index so we get the next number
}

void updateMode(){
//ensures that switches and sliders are working great. 

  // fadeDuration =  map(analogRead(FADE_SPEED_SLIDER_PIN), 0, 1023, 5, 100);
  //globalMax = constrain(map(analogRead(MAX_BRIGHTNESS_KNOB_PIN), 0, 1023, 0, 255),0,255);
  breathe = !digitalRead(BREATHE_STEADY_SWITCH_PIN);
  blue = !digitalRead(WHITE_BLUE_SWITCH_PIN);
  on = !digitalRead(POWER_SWITCH_PIN);
  digitalWrite(13, breathe);

}

