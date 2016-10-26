String ip = "10.0.1.101";
PixelOutput output;


void setup() {
  output = new PixelOutput(ip);
  colorMode(HSB, 1);
}


void draw() {
  output.setPixelColors(color(0, 0, 0));
  RGBPixel pix = output.particles[0];
  fill(pix.r, pix.g, pix.b);
  ellipse(width/2, height/2, 10, 10);
  
  output.sendPackets();
  
}