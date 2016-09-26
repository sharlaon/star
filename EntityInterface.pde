public interface Entity {
  void setupGrowingState(long duration_);
  void drawGrowingState(long frame);
  void setupFlashUpState(long duration_);
  void drawFlashUpState(long frame);
  void setupFlashDownState(long duration_);
  void drawFlashDownState(long frame);
}
