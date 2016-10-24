public class StateManager {
  private Graphics graphics;
  private State states[];
  private int stateIndex;
  private long duration;
  private long lastTime;
  private long lastCountdown;
  private final long countdownDelay = 5000;

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
    lastCountdown = millis() - 5001;
    switchToState(0);
  }

  public void advanceAndDraw() {
    long time = millis() - lastTime;
    if (time > duration) {
      switchToState((stateIndex + 1) % states.length);
      time = millis() - lastTime;
    }
    states[stateIndex].redraw(time);
    graphics.assembleAndPush();

    if (millis() - lastCountdown > 5000) {
      long countdown = duration - time;
      for (int i = (stateIndex + 1) % states.length + 1; i < states.length; ++i) {
        countdown += states[i - 1].duration();
      }
//      loadStrings("http://127.0.0.1:5000/set/" + split(str(countdown), ".")[0]);
      lastCountdown = millis();
    }
  }
}
