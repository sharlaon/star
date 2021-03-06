import hypermedia.net.*;
import java.awt.Color;


public class PixelOutput {
  public color[] particles; // buffer with all particles for all channels
  private String ip;  // address of OPC server
  private int port;

  OPC opc;

  int NUM_LED = 10000;
  int nPixPerChannel = 300; // OPC server is set to 512 pix per channel
  int nChannel = int(NUM_LED / nPixPerChannel);
  int PORT = 7890; //the standard OPC port
  private final float noiseLevel = 1.5;

  boolean firstLoad = true;

  PixelOutput(PApplet parent, String _ip) {
    this.ip = _ip; // the IP address to send packets to
    this.port = PORT;
    this.particles = new color[NUM_LED];

    println(str(particles.length) + " leds in array");
    opc = new OPC(parent, this.ip, PORT);
  }

  int getPixChannel(int ix) {
    return int(ix / nPixPerChannel);
  }

  void setPixelColors(color color_) {
    for (int i = 0; i < this.particles.length; i++) {
      //float saturation =
      //  saturation(color_) >= 0.25
      //  ? (1.0/3.0) * (saturation(color_) - 0.25) + 0.75
      //  : 3.0 * saturation(color_);
      float saturation = saturation(color_);
      float brightness = (1.0 - noiseLevel) + noiseLevel * noise(i, millis() / 1000.0);
      particles[i] = color(hue(color_), saturation, brightness);
    }
  }

  void loadPixelColor(int pixelIndex, color c) {
    particles[pixelIndex] = c;
  }

  void loadPixelColorByChannel() {
    // use this for tests to identify which channel is which
    color curColor;
    for (int ix=0; ix< particles.length; ix++) {
      curColor = color(getPixChannel(ix) / float(nChannel), 1, 1);
      loadPixelColor(ix, curColor);
      // if (firstLoad) {
      //    println(str(getPixChannel(ix)) + " pixel " + str(ix) + " -> h: " + str(hue(particles[ix])) + " s: " + str(saturation(particles[ix])) + " b: " + str(brightness(particles[ix])) );
      //    println(str(getPixChannel(ix)) + " pixel " + str(ix) + " -> r: " + str(red(particles[ix])) + " g: " + str(green(particles[ix])) + " b: " + str(blue(particles[ix])) );
      // }
    }
    firstLoad = false;
  }

  public void update() {
    for (int i = 0; i < NUM_LED; i++) {
      opc.setPixel(i, particles[i]);
    }
    opc.writePixels();

  }

}
