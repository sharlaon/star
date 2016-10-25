// provide upward any interfaces required by Star and Mote.
// it will combine their stimuli into signals for lower-level graphics interfaces,
// such as for the screen, LEDs, strobes, ...
final int SIZE = 640;
final int FRAMERATE = 30;
final int SUNSIZE = 100;
final String ip = "192.168.2.85"; // ip address of BBB, determined by random coin

public void settings() {
  size(SIZE, SIZE, P3D);
}


public class Graphics {

  long time;
  color starColor;
  float starSize, glare;
  private int numberOfMotes;
  private class MoteData {
    public float x, y, z_theta;
    int bright;
  }
  private MoteData[] moteData;

  PImage sprite;
  PShape mote;
  private final float moteSize = 0.008;
  private final float stretch_z = 0.06;

  private PixelOutput pixoutput;

  public Graphics() {
//    frameRate(FRAMERATE);
    colorMode(HSB, 1.0);
    rectMode(CENTER);
    camera(SIZE * 1.5, SIZE/2, -SIZE/2, SIZE/2, SIZE/2, 0.0, 0.0, 0.0, 1.0);

    sprite = loadImage("sprite2.png");
    mote = createShape();
    mote.beginShape(QUAD);
    mote.noStroke();
    mote.texture(sprite);
    //mote.fill(color(280.0 / 360.0, 0.75, 1.0));
    mote.normal(2.0 / sqrt(5), 0.0, -1 / sqrt(5));
    mote.vertex(-SIZE * moteSize / 2.0, -SIZE * moteSize / 2.0, 0, 0);
    mote.vertex(SIZE * moteSize / 2.0, -SIZE * moteSize / 2.0, sprite.width, 0);
    mote.vertex(SIZE * moteSize / 2.0, SIZE * moteSize / 2.0, sprite.width,
      sprite.height);
    mote.vertex(-SIZE * moteSize / 2.0, SIZE * moteSize / 2.0, 0,
      sprite.height);
    mote.endShape();

    pixoutput = new PixelOutput(ip);
  }

  public void setStar(long time_, color starColor_, float starSize_,
      float glare_) {
    time = time_;
    starColor = starColor_;
    starSize = starSize_;
    glare = glare_;
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
    noStroke();

    // hint(DISABLE_DEPTH_MASK);
    // image(backgroundImage, 0, 0, width, height);
    // hint(ENABLE_DEPTH_MASK);

    PImage starImg = createImage(SUNSIZE, SUNSIZE, ARGB);
    starImg.loadPixels();
    for (int x = 0; x < SUNSIZE; ++x) {
      for (int y = 0; y < SUNSIZE; ++y) {
        starImg.pixels[x + SUNSIZE * y] = color(hue(starColor), saturation(starColor),
          (1.0 + noise(x, y, time / 1000.0)) / 2.0);
      }
    }
    starImg.updatePixels();
    PShape star = createShape(SPHERE, starSize * SIZE / 2);
    star.setTexture(starImg);
    pushMatrix();
    rotateY(HALF_PI);
    shape(star);
    popMatrix();

    for (int i = 0; i < numberOfMotes; ++i) {
      pushMatrix();
      float z = sin(moteData[i].z_theta) * stretch_z;
      translate(moteData[i].x * SIZE / 2, moteData[i].y * SIZE / 2, z * SIZE);
      rotateY(-0.4*PI);
      shape(mote);
      popMatrix();
    }

    if (glare != 0.0) {
      hint(DISABLE_DEPTH_TEST);
      pushMatrix();
      rotateY(-0.4*PI);
      fill(1.0, glare);
      rect(0, 0, 1.5*SIZE, 1.5*SIZE);
      popMatrix();
      hint(ENABLE_DEPTH_TEST);
    }
    fill(1.0);
  }

}
