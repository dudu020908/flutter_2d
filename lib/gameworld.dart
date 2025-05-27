import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

import 'bomb.dart';
import 'enemy.dart';
import 'enemy_platform.dart';
import 'moving_platform.dart';
import 'obstacle.dart';
import 'platform.dart';
import 'player.dart';
import 'vanishing_platform.dart';

class GameWorld extends World {
  final Player player;
  // 튜토리얼용 플래그 & 콜백
  final bool isTutorial;
  final VoidCallback? onTutorialDisarm;

  Bomb? bomb;
  Completer<void> _readyCompleter = Completer<void>();
  Future<void> get ready => _readyCompleter.future;

  GameWorld({
    required this.player,
    this.isTutorial = false,
    this.onTutorialDisarm,
  });

  @override
  Future<void> onLoad() async {
    await add(player);
    await Future.delayed(Duration(milliseconds: 50));
    final Random rng = Random();
    final screenSize = player.gameRef.size;

    final double baseY = screenSize.y * 0.65;
    if (isTutorial) {
      final baseY = screenSize.y * 0.75;
      final double platformHeight = screenSize.y * 0.04;
      final double gapX = screenSize.x * 0.18;
      final double gapY = screenSize.y * 0.09;

      final List<PositionComponent> tutorialPlatforms = [];

      // 0. 일반 플랫폼 (시작)
      tutorialPlatforms.add(
        Platform(
          Vector2(50, baseY),
          Vector2(screenSize.x * 0.2, platformHeight),
        ),
      );

      // 1. MovingPlatform
      tutorialPlatforms.add(
        MovingPlatform(
          Vector2(130 + gapX * 1, baseY - gapY * 1),
          Vector2(screenSize.x * 0.2, platformHeight),
          moveBy: Vector2(1, 0),
          speed: 40,
        ),
      );

      // 2. 일반
      tutorialPlatforms.add(
        Platform(
          Vector2(80 + gapX * 2, baseY - gapY * 2),
          Vector2(screenSize.x * 0.2, platformHeight),
        ),
      );

      // 3. EnemyPlatform
      tutorialPlatforms.add(
        EnemyPlatform(
          Vector2(160 + gapX * 3, baseY - gapY * 3),
          enemyBaseSize: Vector2(screenSize.x * 0.025, screenSize.y * 0.03),
        ),
      );

      // 4. 일반
      tutorialPlatforms.add(
        Platform(
          Vector2(200 + gapX * 4, baseY - gapY * 2),
          Vector2(screenSize.x * 0.2, platformHeight),
        ),
      );

      // 5. VanishingPlatform
      tutorialPlatforms.add(
        VanishingPlatform(
          Vector2(300 + gapX * 5, baseY - gapY * 1),
          Vector2(screenSize.x * 0.2, platformHeight),
          this,
        ),
      );

      // 6. 마지막 플랫폼 (폭탄)
      final lastPlatform = Platform(
        Vector2(400 + gapX * 6, baseY),
        Vector2(screenSize.x * 0.3, platformHeight),
      );
      tutorialPlatforms.add(lastPlatform);

      // 플랫폼 추가
      for (final plat in tutorialPlatforms) {
        await add(plat);
        if (plat is EnemyPlatform) {
          final ep = plat;
          final worldTopY = ep.position.y - ep.size.y / 2;
          final enemyH = ep.enemyBaseSize.y * 2;
          final spawnPos = Vector2(ep.position.x, worldTopY - enemyH / 2);

          final minX = ep.position.x - ep.size.x / 2;
          final maxX = ep.position.x + ep.size.x / 2;

          final enemy = Enemy(
            position: spawnPos,
            baseSize: ep.enemyBaseSize,
            minX: minX,
            maxX: maxX,
          )..priority = ep.priority + 1;

          await add(enemy);
        }
      }

      // 폭탄 배치
      final bombPosition = Vector2(
        lastPlatform.position.x + lastPlatform.size.x / 2,
        lastPlatform.position.y,
      );
      bomb = Bomb(bombPosition, onTutorialDisarm: onTutorialDisarm);
      await add(bomb!);

      // 플레이어 시작 위치
      final firstPlatform = tutorialPlatforms.first;
      player.position = Vector2(
        firstPlatform.position.x + 30,
        firstPlatform.position.y - 40,
      );
      player.initialPosition = player.position.clone();

      _readyCompleter.complete();
      return;
    }
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
      if (i == 1) {
        // **두 번째 플랫폼**: ObstaclePlatform
        platform = EnemyPlatform(
          Vector2(x, platformY),
          enemyBaseSize: Vector2(screenSize.x * 0.02, screenSize.y * 0.03),
        );
      } else if (i == vanishingIndex) {
        Obstacle? obstacle;
        if (i % 5 == 4 && i != 29) {
          final double obstacleWidth = screenSize.x * 0.02;
          final double obstacleHeight =
              screenSize.y * (0.04 + rng.nextDouble() * 0.01);

          obstacle = Obstacle(
            Vector2(platformWidth / 2 - obstacleWidth / 2, -obstacleHeight),
            Vector2(obstacleWidth, obstacleHeight),
          );
        }
        platform = VanishingPlatform(
          Vector2(x, platformY),
          Vector2(platformWidth, platformHeight),
          this,
          obstacles: obstacle != null ? [obstacle] : [],
        );
      } else if (movingIndices.contains(i)) {
        platform = MovingPlatform(
          Vector2(x, platformY),
          Vector2(platformWidth, platformHeight),
          moveBy: rng.nextBool() ? Vector2(1, 0) : Vector2(0, 1),
          speed: 40,
        );
      } else {
        platform = Platform(
          Vector2(x, platformY),
          Vector2(platformWidth, platformHeight),
        );
      }
      await add(platform);

      // --- EnemyPlatform 위에 Enemy 스폰하기 ---
      if (i == 1 && platform is EnemyPlatform) {
        // plat 을 EnemyPlatform 으로 캐스트
        final ep = platform as EnemyPlatform;
        final worldTopY = ep.position.y - ep.size.y / 2;
        final enemyH = ep.enemyBaseSize.y * 2;
        final spawnPos = Vector2(ep.position.x, worldTopY - enemyH / 2);

        final minX = ep.position.x - ep.size.x / 2;
        final maxX = ep.position.x + ep.size.x / 2;

        final enemy = Enemy(
          position: spawnPos,
          baseSize: ep.enemyBaseSize,
          minX: minX,
          maxX: maxX,
        )..priority = ep.priority + 1;

        await add(enemy);
      }

      if (i == 29) {
        lastPlatform = platform;
      }

      // 장애물은 5개마다 배치
      // 장애물은 5개마다 배치하되, 마지막 플랫폼(폭탄 위치)에는 제외
      if (i % 5 == 4 && i != 29 && platform is! VanishingPlatform) {
        final double obstacleWidth = screenSize.x * 0.02;
        final double obstacleHeight =
            screenSize.y * (0.04 + rng.nextDouble() * 0.01);

        final obstacle = Obstacle(
          Vector2(platformWidth / 2 - obstacleWidth / 2, 0), // 자식 기준 좌표
          Vector2(obstacleWidth, obstacleHeight),
        );
        platform.add(obstacle);
      }

      x += platformWidth + gap;
    }

    // 마지막 플랫폼 위에 Bomb 추가
    if (lastPlatform != null) {
      final Vector2 bombPosition = Vector2(
        lastPlatform.position.x + lastPlatform.size.x / 2,
        lastPlatform.position.y,
      );
      bomb = Bomb(
        bombPosition,
        onTutorialDisarm: isTutorial ? onTutorialDisarm : null,
      );
      await add(bomb!);
    }

    player.position = Vector2(50, baseY - player.size.y - 1);
    player.initialPosition = Vector2(50, baseY - player.size.y - 1);

    _readyCompleter.complete();
  }
}
