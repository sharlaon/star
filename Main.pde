StateManager stateManager;

void setup() {
  // See also settings() in Graphics.pde
  stateManager = new StateManager();
}

void draw() {
  stateManager.advanceAndDraw();
}
