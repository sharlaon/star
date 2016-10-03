public class MoteClass implements Entity {
  private Graphics graphics;
  private Mote[] motes;
  private final int numberOfMotes = 4; // should probably have log10(numberOfMotes) bewtween 1 and 3

  // any precomputed data or mote state here
  // I'm thinking of a precomputed rendering datum like a PShape that they all share
  // probably offered by Graphics objects

  public MoteClass(Graphics graphics_) {
    graphics = graphics_;
    motes = new Mote[numberOfMotes];
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i] = new Mote(graphics, i); // should instead pass: precomputed mote graphics datum
    }
  }

  public void setupGrowingState(long duration_) {
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i].setupGrowingState(duration_);
    }
  }

  public void drawGrowingState(long frame) {
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i].drawGrowingState(frame);
    }
  }

  public void setupFlashUpState(long duration_) {
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i].setupFlashUpState(duration_);
    }
  }

  public void drawFlashUpState(long frame) {
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i].drawFlashUpState(frame);
    }
  }

  public void setupFlashDownState(long duration_) {
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i].setupFlashDownState(duration_);
    }
  }

  public void drawFlashDownState(long frame) {
    for (int i = 0; i < numberOfMotes; ++i) {
      motes[i].drawFlashDownState(frame);
    }
  }

  private class Mote {
    private Graphics graphics; // again, should be changed
    private int id;
    private long duration;

    // any mote state (position)

    public Mote(Graphics graphics_, int id_) {
      graphics = graphics_;
      id = id_;
    }

    public void setupGrowingState(long duration_) {
      duration = duration_;
      // ...
    }

    public void drawGrowingState(long frame) {
      // ...
    }

    public void setupFlashUpState(long duration_) {
      duration = duration_;
      // ...
    }

    public void drawFlashUpState(long frame) {
      // ...
    }

    public void setupFlashDownState(long duration_) {
      duration = duration_;
      // ...
    }

    public void drawFlashDownState(long frame) {
      // ...
    }
  }
}
