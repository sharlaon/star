// START HERE
// In descending order of abstraction (items generally only depend on others listed to their right), the contents are:
// > Main, State, GrowingState, FlashUpState, FlashDownState, StateInterface, Entity, Star, Mote, EntityInterface, Graphics, ...

StateClass state;
int myFrameRate = 12;

void setup() {
  state = new StateClass();
}

void draw() {
  state.advanceAndDraw();
}
