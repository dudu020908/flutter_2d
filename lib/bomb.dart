import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import 'game.dart'; // 게임 참조
import 'main_menu_screen.dart'; // 메인 메뉴 화면

class Bomb extends PositionComponent with HasGameRef<MyPlatformerGame> {
  double heldDuration = 0; // F 키 누르고 있는 누적 시간
  bool isDisarmed = false; // 해제 여부

  Bomb(Vector2 position) {
    this.position = position;
    size = Vector2(30, 30); // 폭탄 크기
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // 노란색 네모로 폭탄 표시
    canvas.drawRect(size.toRect(), Paint()..color = const Color(0xFFFFD700));
  }

  /// 폭탄을 누르고 있을 때 호출되는 함수
  void updateHolding(bool isHolding, double dt) {
    if (isDisarmed) return; // 이미 해제된 폭탄이면 무시

    if (isHolding) {
      heldDuration += dt;
      if (heldDuration >= 4.0) {
        // 4초 이상 누르면
        disarm();
      }
    } else {
      heldDuration = 0; // 누르지 않으면 시간 초기화
    }
  }

  /// 폭탄 해체 함수
  void disarm() {
    if (isDisarmed) return; // 중복 해체 방지

    isDisarmed = true;
    print("폭탄 해체 성공!");
    removeFromParent(); // 폭탄 제거

    // CLUTCH! 텍스트 추가
    final clutchText =
        TextComponent(
            text: 'CLUTCH!',
            textRenderer: TextPaint(
              style: const TextStyle(
                fontSize: 60,
                color: Colors.redAccent,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
            ),
          )
          ..anchor = Anchor.center
          ..position = gameRef.size / 2; // 화면 정중앙

    gameRef.add(clutchText);

    // 텍스트에 커졌다 작아지는 애니메이션 추가
    clutchText.addAll([
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(
          duration: 0.4,
          reverseDuration: 0.4,
          alternate: true,
          repeatCount: 2,
        ),
      ),
      MoveByEffect(
        Vector2(0, -30),
        EffectController(duration: 1.2),
      ), // 살짝 위로 떠오르기
    ]);

    // 2.5초 뒤 메인 메뉴로 이동
    gameRef.add(
      TimerComponent(
        period: 2.5,
        removeOnFinish: true,
        onTick: () {
          final context = gameRef.buildContext;
          if (context != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainMenuScreen()),
            );
          } else {
            print('⚠️ context is null! 화면 전환 실패');
          }
        },
      ),
    );
  }
}
