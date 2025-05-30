class GameConfig {
  /// 폭탄 해체까지 제한 시간 (초)
  static double bombTimerSeconds = 60.0;

  static void updateBombTimer(double seconds) {
    bombTimerSeconds = seconds;
  }
}
