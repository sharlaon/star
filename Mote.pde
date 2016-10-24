public class Motes implements Entity {
  private Graphics graphics;
  private Mote[] motes;
  private final int numberOfMotes = 1; // should probably have log10(numberOfMotes) bewtween 1 and 3
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
    private Graphics graphics;
    private int id;
    private long duration;

    private final float friction = 0.00001;
    private final float forceConst = 1.0;
    private final float timeConst = 0.001;
    private final float timeConst_z = 0.001;

    private float x, y, z_theta, v_x, v_y;

    private void randomize() {
      float r = random(1.0, 2.0);
      float theta = random(TWO_PI);
      x = r * cos(theta);
      y = r * sin(theta);
      z_theta = random(TWO_PI);
      r = random(1.0);
      theta = random(TWO_PI);
      v_x = r * cos(theta);
      v_y = r * sin(theta);
    }

    public Mote(Graphics graphics_, int id_) {
      graphics = graphics_;
      id = id_;
      randomize();
    }

    public void setupGrowingState(long duration_) {
      duration = duration_;
    }

    public void drawGrowingState(long lastTime, long time) {
      // apply friction
      float r = sqrt(x*x + y*y); // note cos(theta) = x/r, sin(theta) = y/r
      float radial_v = v_x * (x/r) + v_y * (y/r); // projection along (x,y)
      float perp_v_x = v_x - radial_v * (x/r); // complementary components
      float perp_v_y = v_y - radial_v * (y/r);
      v_x -= friction * perp_v_x;
      v_y -= friction * perp_v_y;

      // apply sun's gravity
      float progress = ((float) time) / ((float) duration);
      float sunSize = progress < 0.75
        ? lerp(0.1, 0.4, progress / 0.75)
        : lerp(0.4, 1.0, (progress - 0.75) / 0.25);
      float force = -(forceConst * sunSize * sunSize * sunSize) / (r * r);
      v_x += (force * (x/r)) * (timeConst * (time - lastTime));
      v_y += (force * (y/r)) * (timeConst * (time - lastTime));

      x += v_x * (timeConst * (time - lastTime));
      y += v_y * (timeConst * (time - lastTime));
      z_theta += timeConst_z * (time - lastTime);

      r = sqrt(x*x + y*y);
      if (r < sunSize) {
        randomize();
      }

      graphics.setMote(id, x, y, z_theta);
    }

    public void setupFlashUpState(long duration_) {
      duration = duration_;
    }

    public void drawFlashUpState(long lastTime, long time) {
    }

    public void setupFlashDownState(long duration_) {
      duration = duration_;
    }

    public void drawFlashDownState(long lastTime, long time) {
    }
  }
}
