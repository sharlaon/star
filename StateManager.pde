public class StateManager {
  private Graphics graphics;
  private State states[];
  private int stateIndex;
  private long duration;
  private long lastTime;

  private void switchToState(int stateIndex_) {
    stateIndex = stateIndex_;
    states[stateIndex].setup();
    duration = states[stateIndex].duration();
    lastTime = millis();
  }

  public StateManager() {
    graphics = new Graphics();
    EntityGroup entities = new EntityGroup(graphics);
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
    graphics.assembleAndPush();
  }
}
