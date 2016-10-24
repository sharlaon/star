public class Star implements Entity {
  private Graphics graphics;
  private long duration;
  private color startColor, middleColor, endColor;

  public Star(Graphics graphics_) {
    graphics = graphics_;
  }

  void setupGrowingState(long duration_) {
    duration = duration_;
    startColor = color(210.0 / 256.0, 0.25, 0.5);
    middleColor = color(60.0 / 256.0, 0.5,  0.5);
    endColor = color(0.0, 1.0, 0.5);
  }

  void drawGrowingState(long time) {
    float progress = ((float) time) / ((float) duration);
    color theColor = progress < 0.75
      ? lerpColor(startColor, middleColor, progress / 0.75)
      : lerpColor(middleColor, endColor, (progress - 0.75) / 0.25);
    float size = progress < 0.75
      ? lerp(0.1, 0.4, progress / 0.75)
      : lerp(0.4, 1.0, (progress - 0.75) / 0.25);
    graphics.setStar(time, theColor, size);
  }

  void setupFlashUpState(long duration_) {
    duration = duration_;
    startColor = color(0.0, 1.0, 0.5);
    endColor = color(0.0, 0.0, 1.0);
  }

  void drawFlashUpState(long time) {
    float progress = ((float) time) / ((float) duration);
    color theColor = lerpColor(startColor, endColor, progress);
    float size = 1.0;
    graphics.setStar(time, theColor, size);
  }

  void setupFlashDownState(long duration_) {
    duration = duration_;
    startColor = color(210.0 / 256.0, 0.0, 1.0);
    endColor = color(210.0 / 256.0, 0.25, 0.5);
  }

  void drawFlashDownState(long time) {
    float progress = ((float) time) / ((float) duration);
    color theColor = lerpColor(startColor, endColor, progress);
    float size = lerp(1.0, 0.1, progress);
    graphics.setStar(time, theColor, size);
  }
}
