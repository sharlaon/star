StateManager stateManager;
PApplet rootSketch;

void setup() {
  // See also settings() in Graphics.pde
  stateManager = new StateManager();
  // set the root sketch PApplet handle, for access in deep classes
  rootSketch=this; 
}

void draw() {
  stateManager.advanceAndDraw();
}
