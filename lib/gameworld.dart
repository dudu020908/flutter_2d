import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'obstacle.dart';
import 'platform.dart';
import 'player.dart';
import 'bomb.dart';

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

    for (int i = 0; i < 15; i++) {
      final double yOffset =
          rng.nextDouble() * screenSize.y * 0.04 - screenSize.y * 0.02;
      final double platformY = i == 0 ? baseY : baseY + yOffset;

      final double platformWidth =
          i == 14
              ? screenSize.x * 0.25
              : screenSize.x * (0.15 + rng.nextDouble() * 0.06);
      final double platformHeight = screenSize.y * 0.04;
      final double gap = screenSize.x * (0.05 + rng.nextDouble() * 0.05);

      final platform = Platform(
        Vector2(x, platformY),
        Vector2(platformWidth, platformHeight),
      );
      await add(platform);

      if (i == 14) {
        lastPlatform = platform;
      } else if (i % 3 == 2) {
        final double obstacleWidth = screenSize.x * 0.02;
        final double obstacleHeight =
            screenSize.y * (0.03 + rng.nextDouble() * 0.02);
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

    _readyCompleter.complete(); // bomb 생성 완료 알림
  }
}
