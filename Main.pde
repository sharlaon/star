StateManager stateManager;

void setup() {
  stateManger = new StateManager();
}

void draw() {
  stateManager.advanceAndDraw();
}
