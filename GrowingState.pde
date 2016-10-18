public class GrowingState implements State {
  public long duration() {
    return 45 * 60 * 1000;
  }

  private EntityGroup entities;

  public GrowingState(EntityGroup entities_) {
    entities = entities_;
  }

  public void setup() {
    entities.setupGrowingState(duration());
    entities.drawGrowingState(0);
  }

  public void redraw(long time) {
    entities.drawGrowingState(time);
  }
}
