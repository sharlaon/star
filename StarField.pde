public class StarField implements Entity {
  private Graphics graphics;
  private final int numberOfStars = 30;
  private LittleStar[] stars;

  public StarField(Graphics graphics_) {
    graphics = graphics_;
    stars = new LittleStar[numberOfStars];
    for (int i = 0; i < numberOfStars; ++i) {
      stars[i] = new LittleStar();
    }
    graphics.setStarField(stars);
  }

  void setupGrowingState(long duration_) {
  }

  void drawGrowingState(long time) {
    for (int i = 0; i < numberOfStars; ++i) {
      stars[i].advance();
    }
  }

  void setupFlashUpState(long duration_) {
  }

  void drawFlashUpState(long time) {
    for (int i = 0; i < numberOfStars; ++i) {
      stars[i].advance();
    }
  }

  void setupFlashDownState(long duration_) {
  }

  void drawFlashDownState(long time) {
    for (int i = 0; i < numberOfStars; ++i) {
      stars[i].advance();
    }
  }
}

public class LittleStar {
  private int x_, y_, maxSize, state;

  private final int maxMaxSize = 5;

  private void randomize() {
    x_ = int(random(2 * SIZE));
    y_ = int(random(2 * SIZE));
    maxSize = 1 + int(random(maxMaxSize - 1));
    state = 0;
  }

  public LittleStar() {
    randomize();
  }

  void advance() {
    if (millis() % 5 == 0) {
      ++state;
    }
    if (state > 2 * maxSize + 1) {
      randomize();
    }
  }

  public int x() {
    return x_;
  }

  public int y() {
    return y_;
  }

  public int size() {
    return max(0, maxSize - abs(maxSize - state));
  }
}
