StateClass state;
int myFrameRate = 12;

void setup() {
  state = new StateClass();
}

void draw() {
  state.advanceAndDraw();
}
