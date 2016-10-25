public class FlashUpState implements State {
  public long duration() {
    return 500;
  }

  private EntityGroup entities;

  public FlashUpState(EntityGroup entities_) {
    entities = entities_;
  }

  public void setup() {
    entities.setupFlashUpState(duration());
    entities.drawFlashUpState(0);
  }

  public void redraw(long time) {
    entities.drawFlashUpState(time);
  }
}
