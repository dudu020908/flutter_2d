import 'dart:async' as async;
import 'dart:math';

import 'package:flame/components.dart';

import 'obstacle.dart';
import 'platform.dart';

class VanishingPlatform extends Platform {
  double timeOnPlatform = 0.0;
  bool playerOn = false;
  bool isVanished = false;

  final Vector2 originalPosition;
  final Vector2 originalSize;
  final World world;
  final List<Obstacle> _initialObstacles = [];

  VanishingPlatform(
    Vector2 position,
    Vector2 size,
    this.world, {
    List<Obstacle> obstacles = const [],
  }) : originalPosition = position.clone(),
       originalSize = size.clone(),
       super(position, size) {
    _initialObstacles.addAll(obstacles.map((o) => o.clone()));
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite.sprite = await gameRef.loadSprite('vanishing_platform.png');

    // Obstacle을 초기 자식으로 등록
    for (final o in _initialObstacles) {
      add(o.clone());
    }
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
    sprite.opacity = 1.0;
  }

  void vanish() {
    isVanished = true;
    sprite.opacity = 1.0;

    final savedObstacles = _initialObstacles.map((o) => o.clone()).toList();
    final myWorld = world;

    removeFromParent();

    async.Timer(const Duration(seconds: 3), () async {
      final replatform = VanishingPlatform(
        originalPosition.clone(),
        originalSize.clone(),
        myWorld,
        obstacles: savedObstacles,
      );
      await myWorld.add(replatform);
    });
  }
}
