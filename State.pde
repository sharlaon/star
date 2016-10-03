public class StateClass {
  private Graphics graphics;
  private State states[];
  private int stateIndex;
  private long duration;
  private long lastTime;

  private void switchToState(int newStateIndex) {
    stateIndex = newStateIndex;
    states[stateIndex].setup();
    duration = states[stateIndex].duration();
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
    long time = millis() - lastTime;
    if (time > duration) {
      switchToState((stateIndex + 1) % states.length);
    }
    states[stateIndex].redraw(time);
  }
}
