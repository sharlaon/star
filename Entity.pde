public class EntityClass {
  private Entity[] entities;

  public EntityClass(Graphics graphics) {
    entities = new Entity[] {
      new Star(graphics),
      new MoteClass(graphics)
    };
  }

  public void setupGrowingState(long duration) {
    for (Entity entity : entities)
      entity.setupGrowingState(duration);
  }

  public void drawGrowingState(long frame) {
    for (Entity entity : entities)
      entity.drawGrowingState(frame);
  }

  public void setupFlashUpState(long duration) {
    for (Entity entity : entities)
      entity.setupFlashUpState(duration);
  }

  public void drawFlashUpState(long frame) {
    for (Entity entity : entities)
      entity.drawFlashUpState(frame);
  }

  public void setupFlashDownState(long duration) {
    for (Entity entity : entities)
      entity.setupFlashDownState(duration);
  }

  public void drawFlashDownState(long frame) {
    for (Entity entity : entities)
      entity.drawFlashDownState(frame);
  }
}
