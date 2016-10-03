public class Graphics {
  // provide upward any interfaces required by Star and Mote.
  // it will combine their stimuli into singals for lower-level graphics interfaces,
  // such as for the screen, LEDs, strobes, ...
  public final int myFrameRate = 30;

  long time;
  color starColor;
  float starSize;
  private int numberOfMotes;
  private class MoteData {
    public float r, theta, z;
  }
  private MoteData[] moteData;

  public Graphics() {
    frameRate(myFrameRate);
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

  public void setMote(int id, float r, float theta, float z) {
    moteData[id].r = r;
    moteData[id].theta = theta;
    moteData[id].z = z;
  }
}
