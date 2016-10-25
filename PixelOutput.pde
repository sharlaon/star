import hypermedia.net.*;
import java.awt.Color;

int NUM_LED = 1200;
int nPixPerChannel = 300; // OPC server is set to 512 pix per channel
int nChannel = (NUM_LED / nPixPerChannel);
int PORT = 7890; //the standard OPC port

boolean firstLoad = true;

public class PixelOutput {
  class RGBPixel {
    int i; //linear (global) index
    int channel;
    int r,g,b;
  }

  // constants for creating OPC header
  static final int HEADER_LEN = 4;
  static final int BYTES_PER_PIXEL = 3;
  static final int INDEX_CHANNEL = 0;
  static final int INDEX_COMMAND = 1;
  static final int INDEX_DATA_LEN_MSB = 2;
  static final int INDEX_DATA_LEN_LSB = 3;
  static final int OFFSET_R = 0;
  static final int OFFSET_G = 1;
  static final int OFFSET_B = 2;

  static final int COMMAND_SET_PIXEL_COLORS = 0;


  public RGBPixel[] particles; // buffer with all particles for all channels

  public byte[] packetData;
  private int dataLength = BYTES_PER_PIXEL * nPixPerChannel;
  private int packetLength = HEADER_LEN + dataLength;
  private String ip;
  private int port;
  UDP udp;


  PixelOutput(String _ip) {
    this.ip = _ip;
    this.port = PORT;
    this.particles = new RGBPixel[NUM_LED];
    for (int i=0; i < particles.length; i++) {
      particles[i] = new RGBPixel();
    }
    
    println(str(particles.length) + " leds in array");

    this.packetData = new byte[packetLength];
    this.packetData[INDEX_CHANNEL] = 0; //update this later?
    this.packetData[INDEX_COMMAND] = COMMAND_SET_PIXEL_COLORS;
    this.packetData[INDEX_DATA_LEN_MSB] = (byte)(dataLength >>> 8);
    this.packetData[INDEX_DATA_LEN_LSB] = (byte)(dataLength & 0xFF);
    connect(this.port, true);
  }

  void connect(int port, boolean showLog) {
    // create datagram connection on target port
    udp = new UDP(this, port);
    if (showLog)
      udp.log(true); // uncomment to prinout the connection activity
    udp.listen( true );
  }

  void setPixelColors(color targetColor) {
    loadPixelColorByStrip();
    // for (int i = 0; i < this.particles.length, i++) {
    //   color curColor = targetColor;
    //   //add perlin noise to pixel bright here
    //   loadPixelColor(curColor);
    // }
  }
  void loadPixelColor(int ix, color curColor) {
    // do it the slow way instead of bit shifting beause likely in HSB mode
    particles[ix].i = ix;
    particles[ix].channel = int(ix / nPixPerChannel);
    // scale based on assumption that color is in 0-1 scale
    particles[ix].r = int(red(curColor) * 255);
    particles[ix].g = int(green(curColor) * 255);
    particles[ix].b = int(blue(curColor) * 255);
  }


  void loadPixelColorByStrip() {
    color curColor;
    for (int ix=0; ix< particles.length; ix++) {
      particles[ix].i = ix;
      particles[ix].channel = int(ix / nPixPerChannel);
      // load the color by channel, within 0-1 range
      curColor = color(particles[ix].channel / float(nChannel), 1, 1);

      // scale based on assumption that color is in 0-1 scale
      particles[ix].r = int(red(curColor) * 255);
      particles[ix].g = int(green(curColor) * 255);
      particles[ix].b = int(blue(curColor) * 255);
      if (firstLoad) {
         println(str(particles[ix].channel) + " pixel " + str(ix) + " -> r: " + str(particles[ix].r) + " g: " + str(particles[ix].g) + " b: " + str(particles[ix].b) );
      }
    } 
    firstLoad = false;
  }

  protected byte[] getPacketData(int channel) {
    int channelStart = channel * nPixPerChannel;
    for (int i = channelStart; i < channelStart + nPixPerChannel; ++i) {
      int dataOffset = HEADER_LEN + (i - channelStart) * BYTES_PER_PIXEL;
      RGBPixel pix = particles[channel * nPixPerChannel + i];
      println(str(dataOffset + OFFSET_R));
      // write to same packetData buffer for each channel
      // we get away with this because we are always sending it immediately
      // this may be a problem if the send is asynchronous, and we overwrite the buffer
      this.packetData[dataOffset + OFFSET_R] = (byte) (0xFF & pix.r);
      this.packetData[dataOffset + OFFSET_G] = (byte) (0xFF & pix.g);
      this.packetData[dataOffset + OFFSET_B] = (byte) (0xFF & pix.b);
    }
    return this.packetData;
  }


  public void sendPackets() {
    byte[] packet;
    println("sending packet");
    for (int channel = 0; channel < nChannel; channel++) {
      packet = getPacketData(channel);
      udp.send(packet, this.ip, this.port);
    }
  }

}