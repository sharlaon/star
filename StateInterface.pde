public interface State {
  long duration(); // I can't figure out how to attach an abstract const to an interface in Java.
  void setup(); // CANNOT be dependent on millis()!
  void advanceAndDraw();
}
