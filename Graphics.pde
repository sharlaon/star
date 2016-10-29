import hypermedia.net.*;

// provide upward any interfaces required by Star and Mote.
// it will combine their stimuli into signals for lower-level graphics interfaces,
// such as for the screen, LEDs, strobes, ...
final int SIZE = 640;
final int FRAMERATE = 30;
final int SUNSIZE = 200;

final String BBB_ip = "10.0.1.101"; // ip address of BBB, determined by random coin
final String PWM_ip1 = "10.0.1.110";
final String PWM_ip2 = "10.0.1.111";
final int PWM_port = 6038;

public void settings() {
  size(SIZE, SIZE, P3D);
  fullScreen();
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
  private LittleStar[] starField;

  PImage sprite;
  PShape mote;
  private final float moteSize = 0.02;
  private final float stretch_z = 0.06;

  private PixelOutput pixoutput;
  private UDP udp;

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

    pixoutput = new PixelOutput(rootSketch, BBB_ip);
    udp = new UDP(this, 6000);
  }

  public void setStar(long time_, color starColor_, float starSize_,
      float glare_) {
    time = time_;
    starColor = starColor_;
    starSize = starSize_;
    glare = glare_;
    pixoutput.setPixelColors(starColor);
    pixoutput.update();
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

  public void setStarField(LittleStar[] starField_) {
    starField = starField_;
  }

  public void setFlash(float flash) {
    byte[] bytes = new byte[2];
    bytes[0] = byte(int(flash * 255.9));
    bytes[1] = byte(int(flash * 65535.5 - int(flash * 255.9) * 256));
    udp.send(bytes, PWM_ip1, PWM_port);
  }

  public void assembleAndPush() {
    background(0);
    noStroke();

    pushMatrix();
    rotateY(-0.4*PI);
    translate(-SIZE, 0.0, -SIZE);
//    fill(0.75, 0.5);
    for (int i = 0; i < starField.length; ++i) {
      ellipse(starField[i].x(), starField[i].y(), starField[i].size(),
        starField[i].size());
    }
    fill(1.0, 1.0);
    popMatrix();

    translate(SIZE/2, SIZE/2, 0);

    PImage starImg = createImage(SUNSIZE, SUNSIZE, ARGB);
    starImg.loadPixels();
    long curTime = millis();
    for (int x = 0; x < SUNSIZE; ++x) {
      for (int y = 0; y < SUNSIZE; ++y) {
        starImg.pixels[x + SUNSIZE * y] = color(hue(starColor), saturation(starColor),
          (1.0 + noise(x, y, curTime / 1000.0)) / 2.0);
      }
    }
    starImg.updatePixels();
    PShape star = createShape(SPHERE, starSize * SIZE / 2);
    star.setTexture(starImg);
    pushMatrix();
    rotateY(HALF_PI);
    shape(star);
    popMatrix();

    stroke(starColor, 0.6);
    beginShape(LINES);
    for (int i = 0; i < 400; ++i) {
      PVector v = PVector.random3D();
      float x = v.x, y = v.y, z = v.z;
      float x1 = 1.03 * v.x * starSize * SIZE / 2, x2 = 1.05 * x1;
      float y1 = 1.03 * v.y * starSize * SIZE / 2, y2 = 1.05 * y1;
      float z1 = 1.03 * v.z * starSize * SIZE / 2, z2 = 1.05 * z1;
      vertex(x1, y1, z1);
      vertex(x2, y2, z2);
    }
    endShape();

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
      rotateY(-0.35*PI);
      fill(1.0, glare);
      rect(0, 0, 2.5*SIZE, 2.5*SIZE);
      popMatrix();
      hint(ENABLE_DEPTH_TEST);
      setFlash(glare);
    }
    fill(1.0);
  }

}