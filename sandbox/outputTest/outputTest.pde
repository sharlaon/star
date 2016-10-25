String ip = "192.168.2.85";
PixelOutput output;


void setup() {
  output = new PixelOutput(ip);
  colorMode(HSB, 1);
}


void draw() {
  output.setPixelColors(color(0, 0, 0));
  //output.sendPackets();
  
}