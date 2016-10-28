import hypermedia.net.*;
import java.awt.Color;


public class PixelOutput {
  public color[] particles; // buffer with all particles for all channels
  private String ip;  // address of OPC server
  private int port;

  OPC opc;

  int NUM_LED = 1200;
  int nPixPerChannel = 300; // OPC server is set to 512 pix per channel
  int nChannel = int(NUM_LED / nPixPerChannel);
  int PORT = 7890; //the standard OPC port

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

  void setPixelColors(color targetColor, boolean useNoise) {
    for (int i = 0; i < this.particles.length; i++) {
      float bright = 1;
      if (firstLoad)
        println("useNoise: " + str(useNoise));
      if (useNoise) {
        // MJP: I think this scaling makes sense? aiming for noise between 0.8-1.0
        // I don't think it is applying it along the particles the way i want it to...
        bright = 0.8 + noise(i, millis() / 1000.0) /  0.2;
      }
      particles[i] = color(hue(targetColor), saturation(targetColor), bright);
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