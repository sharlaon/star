public class Motes implements Entity {
  private Graphics graphics;
  private Mote[] motes;
  private final int numberOfMotes = 4; // should probably have log10(numberOfMotes) bewtween 1 and 3
  long lastTime;

  public Motes(Graphics graphics_) {
    graphics = graphics_;
    graphics.setNumberOfMotes(numberOfMotes);
    motes = new Mote[numberOfMotes];
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i] = new Mote(graphics, i);
    }
  }

  public void setupGrowingState(long duration_) {
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i].setupGrowingState(duration_);
    }
    lastTime = 0;
  }

  public void drawGrowingState(long time) {
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i].drawGrowingState(lastTime, time);
    }
    lastTime = time;
  }

  public void setupFlashUpState(long duration_) {
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i].setupFlashUpState(duration_);
    }
    lastTime = 0;
  }

  public void drawFlashUpState(long time) {
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i].drawFlashUpState(lastTime, time);
    }
    lastTime = time;
  }

  public void setupFlashDownState(long duration_) {
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i].setupFlashDownState(duration_);
    }
    lastTime = 0;
  }

  public void drawFlashDownState(long time) {
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i].drawFlashDownState(lastTime, time);
    }
    lastTime = time;
  }

  private class Mote {
    private Graphics graphics; // again, should be changed
    private int id;
    private long duration;

    private float r, theta, z;

    public Mote(Graphics graphics_, int id_) {
      graphics = graphics_;
      id = id_;

      r = random(0.1, 1.0);
      theta = random(TWO_PI);
      z = random(-1.0, 1.0);
    }

    public void setupGrowingState(long duration_) {
      duration = duration_;
      // ...
    }

    public void drawGrowingState(long lastTime, long time) {
      // ...
      graphics.setMote(id, r, z, theta);
    }

    public void setupFlashUpState(long duration_) {
      duration = duration_;
      // ...
    }

    public void drawFlashUpState(long lastTime, long time) {
      // ...
    }

    public void setupFlashDownState(long duration_) {
      duration = duration_;
      // ...
    }

    public void drawFlashDownState(long lastTime, long time) {
      // ...
    }
  }
}
