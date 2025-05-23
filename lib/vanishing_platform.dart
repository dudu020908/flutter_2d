import 'dart:async' as async;
import 'dart:math';

import 'package:flame/components.dart';

import 'platform.dart';

class VanishingPlatform extends Platform {
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
  Future<void> onLoad() async {
    await super.onLoad();
    sprite.sprite = await gameRef.loadSprite('vanishing_platform.png');
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (playerOn && !isVanished) {
      timeOnPlatform += dt;

      if (timeOnPlatform >= 1.2 && timeOnPlatform < 1.5) {
        final blinkPhase = (timeOnPlatform - 1.2) * 10 * pi;
        sprite.opacity = 0.3 + 0.7 * ((1 + sin(blinkPhase)) / 2);
        final scaleFactor = 0.95 + 0.1 * ((1 + sin(blinkPhase)) / 2);
        scale.setValues(scaleFactor, scaleFactor);
      }

      if (timeOnPlatform >= 1.5) {
        scale.setValues(1.0, 1.0);
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
    sprite.opacity = 1.0; // 플레이어가 떠나면 원래 투명도로 복구
  }

  void vanish() {
    isVanished = true;
    sprite.opacity = 1.0; // 사라질 때 다시 원래 상태로 복구

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
