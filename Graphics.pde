public class Graphics {
  // provide upward any interfaces required by Star and Mote.
  // it will combine their stimuli into singals for lower-level graphics interfaces,
  // such as for the screen, LEDs, strobes, ...
  public final int myFrameRate = 30;

  public Graphics() {
    frameRate(myFrameRate);
  }

  public setStar(long frame, color theColor, double size) {
  }
}
