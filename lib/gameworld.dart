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
    // 게임 시작 시 플레이어를 월드에 먼저 추가
    await add(player);
    await Future.delayed(Duration(milliseconds: 50)); // 크기 설정까지 약간 기다림
    final Random rng = Random();
    final screenSize =
        player.gameRef.size; // 현재 기기의 가상 해상도 기준 크기 (예: 1920x1080)

    // 전체 화면 높이의 65% 지점에 첫 플랫폼을 배치 (바닥 기준)
    final double baseY = screenSize.y * 0.65;

    double x = 0; // 플랫폼 시작 x 좌표 (왼쪽 끝부터 시작)

    // 총 60개의 플랫폼과 일부 장애물 생성
    for (int i = 0; i < 60; i++) {
      // 플랫폼의 수직 위치에 랜덤 오프셋 추가 → y 축으로 살짝 위아래로 흔들림 효과
      // - offset 범위: [-2%, +2%] (즉, 총 4% 범위 내에서 랜덤 위치 조정)
      final double yOffset =
          rng.nextDouble() * screenSize.y * 0.04 - screenSize.y * 0.02;
      final double platformY = i == 0 ? baseY : baseY + yOffset;

      // 플랫폼의 크기 (가로 길이): 화면 너비의 15~21% 사이에서 랜덤 결정
      final double platformWidth =
          screenSize.x * (0.15 + rng.nextDouble() * 0.06);

      // 플랫폼의 높이: 화면 높이의 4%로 고정
      final double platformHeight = screenSize.y * 0.04;

      // 각 플랫폼 사이 간격: 화면 너비의 5~10% 사이에서 랜덤 결정
      final double gap = screenSize.x * (0.05 + rng.nextDouble() * 0.05);

      // 실제 플랫폼 생성 후 월드에 추가
      final platform = Platform(
        Vector2(x, platformY), // 위치: x, y
        Vector2(platformWidth, platformHeight), // 크기: 너비, 높이
      );
      await add(platform);

      // 장애물은 3개마다 1번 생성 (i = 2, 5, 8, ...)
      if (i % 3 == 2) {
        // 장애물 너비: 화면 너비의 2%
        final double obstacleWidth = screenSize.x * 0.02;

        // 장애물 높이: 화면 높이의 3~5% 사이에서 랜덤 설정
        final double obstacleHeight =
            screenSize.y * (0.03 + rng.nextDouble() * 0.02);

        // 장애물 위치: 플랫폼 위에 살짝 떠 있도록 설정 (플랫폼 위에 바로 붙지 않고, 정확히 위에 생성)
        final double obstacleY = platformY - obstacleHeight;

        await add(
          Obstacle(
            Vector2(
              x + platformWidth / 2 - obstacleWidth / 2,
              obstacleY,
            ), // 플랫폼 중앙에 위치
            Vector2(obstacleWidth, obstacleHeight),
          ),
        );
      }

      // 다음 플랫폼의 시작 x 위치 갱신
      x += platformWidth + gap;
    }

    // 플레이어 초기 위치 설정:
    // - x는 왼쪽 여백 50
    // - y는 첫 플랫폼 바로 위에 착지한 상태가 되도록 보정
    player.position = Vector2(50, baseY - player.size.y - 1);
    player.initialPosition = Vector2(50, baseY - player.size.y - 1);
  }
}
