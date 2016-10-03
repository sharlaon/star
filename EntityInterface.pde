public interface Entity {
  void setupGrowingState(long duration_);
  void drawGrowingState(long time);
  void setupFlashUpState(long duration_);
  void drawFlashUpState(long time);
  void setupFlashDownState(long duration_);
  void drawFlashDownState(long time);
}
