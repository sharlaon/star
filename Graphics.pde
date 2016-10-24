// provide upward any interfaces required by Star and Mote.
// it will combine their stimuli into singals for lower-level graphics interfaces,
// such as for the screen, LEDs, strobes, ...
final int SIZE = 640;
final int FRAMERATE = 30;

public void settings() {
  size(SIZE, SIZE, P3D);
}

public class Graphics {

  long time;
  color starColor;
  float starSize;
  private int numberOfMotes;
  private class MoteData {
    public float x, y, z_theta;
    int bright;
  }
  private MoteData[] moteData;

  PShape star;
  PShape mote;
  private final float moteSize = 0.05;
  private final float stretch_z = 0.05;

  public Graphics() {
    frameRate(FRAMERATE);
    colorMode(HSB, 1.0);
    rectMode(CENTER);
    star = createShape(SPHERE, 1.0);
    mote = createShape(RECT, 0, 0, 20, 20);
    // decorate the mote
  }

  public void setStar(long time_, color starColor_, float starSize_) {
    time = time_;
    starColor = starColor_;
    starSize = starSize_;
  }

  public void setNumberOfMotes(int numberOfMotes_) {
    numberOfMotes = numberOfMotes_;
    moteData = new MoteData[numberOfMotes];
    for (int i = 0; i < numberOfMotes; ++i) {
      moteData[i] = new MoteData();
    }
  }

  public void setMote(int id, float x, float y, float z_theta, int bright) {
    moteData[id].x = x;
    moteData[id].y = y;
    moteData[id].z_theta = z_theta;
    moteData[id].bright = bright;
  }

  public void assembleAndPush() {
    background(0);
    translate(SIZE/2, SIZE/2, 0);

    // hint(DISABLE_DEPTH_MASK);
    // image(backgroundImage, 0, 0, width, height);
    // hint(ENABLE_DEPTH_MASK);

    // decorate star
    fill(starColor);
    sphere(starSize * SIZE / 2);
//    shape(star);

    for (int i = 0; i < numberOfMotes; ++i) {
      pushMatrix();
      float z = sin(moteData[i].z_theta) * stretch_z;
      translate(moteData[i].x * SIZE / 2, moteData[i].y * SIZE / 2, 0);
      fill(color(280.0 / 360.0, 0.75, ((float) moteData[i].bright) / ((float) FRAMERATE)));
      rect(0, 0, 20, 20);
//      shape(mote);
      popMatrix();
    }
  }
}
