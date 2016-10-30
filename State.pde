public interface State {
  void recomputeDuration();
  long duration();
  void setup(); // CANNOT be dependent on millis()!
  void redraw(long time);
}
