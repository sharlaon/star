import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Main extends PApplet {

public void setup() {
  setupStates();
  setupMotes();
  setupStar();

  frameRate(30);

  switchToState(0);
}

public void draw() {
  advanceStateAndDraw();
}
class FlashDownState implements State {
  FlashDownState() {
  }
  
  public long Duration() {
    return 3 * 60 * 1000;
  }
  
  public void Setup() {
  }
  
  public void Draw() {
  }
}
class FlashUpState implements State {
  FlashUpState() {
  }
  
  public long Duration() {
    return 1 * 60 * 1000;
  }
  
  public void Setup() {
  }
  
  public void Draw() {
  }
}
class GrowingState implements State {
  GrowingState() {
  }
  
  public long Duration() {
    return 3 * 60 * 1000;
  }
  
  public void Setup() {
  }
  
  public void Draw() {
  }
}
// Declare global Mote state here.
// I'm thinking of a precomputed rendering datum like a PShape that they all use.

public void initMoteGraphics() {
  // render the datum
}

class Mote {
  PVector position;
  Mote() {
  }
  Mote(PVector pos) {
    position = pos;
  }
  public void draw() {
  }
}

Mote[] motes;
int NumberOfMotes = 4;
public void setupMotes() {
  motes = new Mote[NumberOfMotes];
  for (int i = 0; i < NumberOfMotes; ++i) {
    motes[i] = new Mote();
  }
}
class Star {
  Star() {
  }
}

Star star;
public void setupStar() {
  star = new Star();
}
interface State {
  public long Duration();
  public void Setup();
  public void Draw();
}

State states[];

public void setupStates() {
  states = new State[] {
    new GrowingState(),
    new FlashUpState(),
    new FlashDownState()
  };
}

long frame;
int state;
long lastTime;

public void switchToState(int newState) {
  frame = 0;
  state = newState;
  states[state].Setup();
  lastTime = millis();
}

public void advanceStateAndDraw() {
  ++frame;
  if (millis() - lastTime > states[state].Duration()) {
    switchToState((state + 1) % 3);
  }
  states[state].Draw();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
