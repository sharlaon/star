public class FlashDownState implements State {
  public long duration() {
    return 3 * 1000;
  }
  private long frame;

  private EntityClass entities;

  public FlashDownState(EntityClass entities_) {
    entities = entities_;
  }

  public void setup() {
    entities.setupFlashDownState(duration());
    entities.drawFlashDownState(0);
  }

  public void advanceAndDraw() {
    ++frame;
    entities.drawFlashDownState(frame);
  }
}
