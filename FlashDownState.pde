public class FlashDownState implements State {
  public void recomputeDuration() {}

  public long duration() {
    return 5 * 1000;
  }

  private EntityGroup entities;

  public FlashDownState(EntityGroup entities_) {
    entities = entities_;
  }

  public void setup() {
    entities.setupFlashDownState(duration());
    entities.drawFlashDownState(0);
  }

  public void redraw(long time) {
    entities.drawFlashDownState(time);
  }
}
