import hypermedia.net.*;
import java.awt.Color;

int NUM_LED = 1200;
int nPixPerChannel = 300; // OPC server is set to 512 pix per channel
int nChannel = int(NUM_LED / nPixPerChannel);
int PORT = 7890; //the standard OPC port

boolean firstLoad = true;

public class PixelOutput {

  public color[] particles; // buffer with all particles for all channels
  private String ip;  // address of OPC server
  private int port;

  OPC opc;

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

  void setPixelColors(color targetColor) {
    loadPixelColorByStrip();
    // for (int i = 0; i < this.particles.length, i++) {
    //   color curColor = targetColor;
    //   //add perlin noise to pixel bright here
    //   loadPixelColor(curColor);
    // }
  }
  
  void loadPixelColor(int pixelIndex, color c) {
    particles[pixelIndex] = c;
  }

  void loadPixelColorByStrip() {
    color curColor;
    for (int ix=0; ix< particles.length; ix++) {
      curColor = color(getPixChannel(ix) / float(nChannel), 1, 1);
      loadPixelColor(ix, curColor);
      if (firstLoad) {
         println(str(getPixChannel(ix)) + " pixel " + str(ix) + " -> h: " + str(hue(particles[ix])) + " s: " + str(saturation(particles[ix])) + " b: " + str(brightness(particles[ix])) );
         println(str(getPixChannel(ix)) + " pixel " + str(ix) + " -> r: " + str(red(particles[ix])) + " g: " + str(green(particles[ix])) + " b: " + str(blue(particles[ix])) );
      }
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