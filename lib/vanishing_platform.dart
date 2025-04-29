import 'dart:async' as async;

import 'package:flame/components.dart';

import 'game.dart';
import 'gameworld.dart';
import 'platform.dart';

class VanishingPlatform extends Platform with HasGameRef<MyPlatformerGame> {
  double timeOnPlatform = 0.0;
  bool playerOn = false;
  bool isVanished = false;

  final Vector2 originalPosition;
  final Vector2 originalSize;
  final World world;

  VanishingPlatform(Vector2 position, Vector2 size, this.world)
    : originalPosition = position.clone(),
      originalSize = size.clone(),
      super(position, size);

  @override
  void update(double dt) {
    super.update(dt);

    if (playerOn && !isVanished) {
      timeOnPlatform += dt;

      // 🔥 사라지기 직전 깜빡이기 시작
      if (timeOnPlatform >= 1.2 && timeOnPlatform < 1.5) {
        double blinkTime = (timeOnPlatform - 1.2) * 5; // 0~1.5 구간 5배속
        opacity = (blinkTime % 1.0) < 0.5 ? 1.0 : 0.3; // 번갈아 깜빡
      }

      if (timeOnPlatform > 1.5) {
        vanish();
      }
    }
  }

  void onPlayerTouch() {
    playerOn = true;
  }

  void onPlayerLeave() {
    playerOn = false;
    timeOnPlatform = 0.0;
    opacity = 1.0; // 플레이어가 떠나면 원래 투명도로 복구
  }

  void vanish() {
    isVanished = true;
    opacity = 1.0; // 사라질 때 다시 원래 상태로 복구

    final myWorld = world;
    removeFromParent();

    async.Timer(const Duration(seconds: 3), () {
      final replatform = VanishingPlatform(
        originalPosition.clone(),
        originalSize.clone(),
        myWorld,
      );
      myWorld.add(replatform);
    });
  }
}
