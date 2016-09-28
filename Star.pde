public class Star implements Entity {
  private Graphics graphics;
  private long duration;

  public Star(Graphics graphics_) {
    graphics = graphics_;
  }

  void setupGrowingState(long duration_) {
    duration = duration_;
  }

  void drawGrowingState(long frame) {
  }

  void setupFlashUpState(long duration_) {
    duration = duration_;
  }

  void drawFlashUpState(long frame) {
  }

  void setupFlashDownState(long duration_) {
    duration = duration_;
  }

  void drawFlashDownState(long frame) {
  }
}
