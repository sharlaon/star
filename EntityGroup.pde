public class EntityGroup {
  private Entity[] entities;

  public EntityGroup(Graphics graphics) {
    entities = new Entity[] {
      new Star(graphics),
      new Motes(graphics),
      new StarField(graphics)
    };
  }

  public void setupGrowingState(long duration) {
    for (Entity entity : entities){
      entity.setupGrowingState(duration);
    }
  }

  public void drawGrowingState(long time) {
    for (Entity entity : entities) {
      entity.drawGrowingState(time);
    }
  }

  public void setupFlashUpState(long duration) {
    for (Entity entity : entities) {
      entity.setupFlashUpState(duration);
    }
  }

  public void drawFlashUpState(long time) {
    for (Entity entity : entities) {
      entity.drawFlashUpState(time);
    }
  }

  public void setupFlashDownState(long duration) {
    for (Entity entity : entities) {
      entity.setupFlashDownState(duration);
    }
  }

  public void drawFlashDownState(long frame) {
    for (Entity entity : entities) {
      entity.drawFlashDownState(frame);
    }
  }
}
