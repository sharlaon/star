public class FlashUpState implements State {
  public long duration() {
    return 1 * 1000;
  }
  private long frame;

  private EntityClass entities;

  public FlashUpState(EntityClass entities_) {
    entities = entities_;
  }

  public void setup() {
    entities.setupFlashUpState(duration());
    entities.drawFlashUpState(0);
  }

  public void advanceAndDraw() {
    ++frame;
    entities.drawFlashUpState(frame);
  }
}
