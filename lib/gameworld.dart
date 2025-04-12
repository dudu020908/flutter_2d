import 'dart:math';

import 'package:flame/components.dart';

import 'obstacle.dart';
import 'platform.dart';
import 'player.dart';

class GameWorld extends World {
  final Player player;
  GameWorld({required this.player});

  @override
  Future<void> onLoad() async {
    await add(player);

    final Random rng = Random();
    final screenSize = player.gameRef.size;
    final double baseY = screenSize.y * 0.65;
    double x = 0;

    // 플랫폼 배치 및 배경 설정
    for (int i = 0; i < 60; i++) {
      final double yOffset = rng.nextDouble() * 60 - 30;
      final double platformY = i == 0 ? baseY : baseY + yOffset;
      final double platformWidth = 160 + rng.nextDouble() * 80;
      final double gap = 80 + rng.nextDouble() * 80;

      final platform = Platform(
        Vector2(x, platformY),
        Vector2(platformWidth, 20),
      );
      await add(platform);

      // 장애물 추가
      if (i % 3 == 2) {
        final double obstacleHeight = 20 + rng.nextDouble() * 15;
        final double obstacleY = platformY - obstacleHeight;
        await add(
          Obstacle(
            Vector2(x + platformWidth / 2 - 15, obstacleY),
            Vector2(30, obstacleHeight),
          ),
        );
      }

      x += platformWidth + gap; // 플랫폼 간격
    }

    // 플레이어 초기 위치 설정
    player.position = Vector2(50, baseY - player.size.y - 1);
  }
}
