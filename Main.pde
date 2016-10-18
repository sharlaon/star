StateManager stateManager;

void setup() {
  stateManager = new StateManager();
}

void draw() {
  stateManager.advanceAndDraw();
}
