import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';

import 'bomb.dart';
import 'moving_platform.dart';
import 'obstacle.dart';
import 'platform.dart';
import 'player.dart';
import 'vanishing_platform.dart';

class GameWorld extends World {
  final Player player;
  Bomb? bomb;
  Completer<void> _readyCompleter = Completer<void>();
  Future<void> get ready => _readyCompleter.future;

  GameWorld({required this.player});

  @override
  Future<void> onLoad() async {
    await add(player);
    await Future.delayed(Duration(milliseconds: 50));
    final Random rng = Random();
    final screenSize = player.gameRef.size;

    final double baseY = screenSize.y * 0.65;
    double x = 0;

    Platform? lastPlatform;

    // 미리 지정된 특별 플랫폼 인덱스
    final vanishingIndex = rng.nextInt(30);
    List<int> movingIndices = [];
    while (movingIndices.length < 2) {
      int index = rng.nextInt(30);
      if (index != vanishingIndex && !movingIndices.contains(index)) {
        movingIndices.add(index);
      }
    }

    for (int i = 0; i < 30; i++) {
      final double yOffset =
          rng.nextDouble() * screenSize.y * 0.08 - screenSize.y * 0.04;
      final double platformY = (i == 0) ? baseY : (baseY + yOffset);

      final double platformWidth =
          i == 29
              ? screenSize.x * 0.25
              : screenSize.x * (0.1 + rng.nextDouble() * 0.12);
      final double platformHeight = screenSize.y * 0.04;
      final double gap = screenSize.x * (0.04 + rng.nextDouble() * 0.08);

      Platform platform;
      if (i == vanishingIndex) {
        platform = VanishingPlatform(
          Vector2(x, platformY),
          Vector2(platformWidth, platformHeight),
          this,
        );
      } else if (movingIndices.contains(i)) {
        Vector2 moveDir = rng.nextBool() ? Vector2(1, 0) : Vector2(0, 1);
        platform = MovingPlatform(
          Vector2(x, platformY),
          Vector2(platformWidth, platformHeight),
          moveBy: moveDir,
          speed: 40,
        );
      } else {
        platform = Platform(
          Vector2(x, platformY),
          Vector2(platformWidth, platformHeight),
        );
      }

      await add(platform);

      if (i == 29) {
        lastPlatform = platform;
      }

      // 장애물은 5개마다 배치
      // 장애물은 5개마다 배치하되, 마지막 플랫폼(폭탄 위치)에는 제외
      if (i % 5 == 4 && i != 29) {
        final double obstacleWidth = screenSize.x * 0.02;
        final double obstacleHeight =
            screenSize.y * (0.03 + rng.nextDouble() * 0.03);
        final double obstacleY = platformY - obstacleHeight;

        await add(
          Obstacle(
            Vector2(x + platformWidth / 2 - obstacleWidth / 2, obstacleY),
            Vector2(obstacleWidth, obstacleHeight),
          ),
        );
      }

      x += platformWidth + gap;
    }

    // 마지막 플랫폼 위에 Bomb 추가
    if (lastPlatform != null) {
      final Vector2 bombPosition = Vector2(
        lastPlatform.position.x + lastPlatform.size.x / 2 - 16,
        lastPlatform.position.y - 32,
      );
      bomb = Bomb(bombPosition);
      await add(bomb!);
    }

    player.position = Vector2(50, baseY - player.size.y - 1);
    player.initialPosition = Vector2(50, baseY - player.size.y - 1);

    _readyCompleter.complete();
  }
}
