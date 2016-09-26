public class StateClass {
  private Graphics graphics;
  private State states[];
  private int stateIndex;
  private long duration;
  private long lastTime;

  private void switchToState(int newStateIndex) {
    stateIndex = newStateIndex;
    states[stateIndex].setup();
    duration =  graphics.myFrameRate * states[stateIndex].duration() / 1000;
    lastTime = millis();
  }

  public StateClass() {
    graphics = new Graphics();
    EntityClass entities = new EntityClass(graphics);
    states = new State[] { // playlist, as it were
      new GrowingState(entities),
      new FlashUpState(entities),
      new FlashDownState(entities)
    };
    switchToState(0);
  }

  public void advanceAndDraw() {
    if (millis() - lastTime > duration) {
      switchToState((stateIndex + 1) % states.length);
    }
    states[stateIndex].advanceAndDraw();
  }
}
