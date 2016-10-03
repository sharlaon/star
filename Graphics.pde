public class Graphics {
  // provide upward any interfaces required by Star and Mote.
  // it will combine their stimuli into singals for lower-level graphics interfaces,
  // such as for the screen, LEDs, strobes, ...
  public final int myFrameRate = 30;
  private int numberOfMotes;
  private int[] moteData; // the type "int" will be replaced probably with a position

  public Graphics() {
    frameRate(myFrameRate);
  }

  public setStar(long frame, color theColor, double size) {
  }

  public setNumberOfMotes(int numberOfMotes_) {
    numberOfMotes = numberOfMotes_;
    moteData = new int[numberOfMotes];
  }

  public setMote(int id, int data) {
    moteData[id] = data;
  }
}
