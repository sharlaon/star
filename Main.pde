StateManager stateManager;
Arduino arduino;

void setup() {
  // See also settings() in Graphics.pde
//  arduino = new Arduino(this, Arduino.list()[ARDUINO_PORT], 57600);
  stateManager = new StateManager();
}

void draw() {
  stateManager.advanceAndDraw();
}
