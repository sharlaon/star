String ip = "10.0.1.101";
PixelOutput output;


void setup() {
  size(200, 100);
  output = new PixelOutput(this, ip);
  colorMode(HSB, 1);
}


void draw() {
  //println("--");
  output.setPixelColors(color(0.6, 1, 1));
  displayChannelFirstPixel();
  output.update();
  
}

void displayChannelFirstPixel() {
    colorMode(RGB, 255);
  for (int i=0; i < 4; i++) {
    color pix = output.particles[i * 300];
     // add the first pixel so we see what color we are trying to show
    fill(pix);
    noStroke();
    int xoff = (width/5) * (i+1); 
    ellipse(xoff, height/2, 20, 20);
    //println(str(i) + " " + xoff);
    //println(str(pix.r) + " " + str(pix.g) + " " + str(pix.b));
  }
  colorMode(HSB, 1);
}