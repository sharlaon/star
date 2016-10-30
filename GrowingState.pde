public class GrowingState implements State {
  private long computedDuration;

  public void recomputeDuration() {
    String[] scheduleStrings = loadStrings("schedule.txt");
    int[] scheduleTimes = new int[scheduleStrings.length];
    for (int i = 0; i < scheduleStrings.length; ++i) {
      int[] scheduleTimesParsed = int(split(scheduleStrings[i], ":"));
      if (scheduleTimesParsed[0] < 12) {
        scheduleTimesParsed[0] += 24;
      }
      scheduleTimes[i] = 60 * scheduleTimesParsed[0] + scheduleTimesParsed[1];
    }
    int currentHour = hour();
    if (currentHour < 12) {
      currentHour += 24;
    }
    int currentTime = 60 * currentHour + minute();
    int index = 0;
    while (currentTime >= scheduleTimes[index] - 2) ++index;
    // computedDuration = (60 * (scheduleTimes[index] - currentTime)) * 1000;
    // print("Next flash in: "); println(computedDuration);
    computedDuration = 60 * 1000;
  }

  public long duration() {
    return computedDuration;
  }

  private EntityGroup entities;

  public GrowingState(EntityGroup entities_) {
    entities = entities_;
  }

  public void setup() {
    recomputeDuration();
    entities.setupGrowingState(duration());
    entities.drawGrowingState(0);
  }

  public void redraw(long time) {
    entities.drawGrowingState(time);
  }
}
