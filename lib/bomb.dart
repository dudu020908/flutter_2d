import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:my_platformer_game/game.dart';
import 'dart:ui';

import 'main_menu_screen.dart';

class Bomb extends PositionComponent with HasGameRef<MyPlatformerGame> {
  double heldDuration = 0;
  bool isDisarmed = false;

  Bomb(Vector2 position) {
    this.position = position;
    size = Vector2(30, 30);
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), Paint()..color = const Color(0xFFFFD700));
  }

  void updateHolding(bool isHolding, double dt) {
    if (isDisarmed) return;

    if (isHolding) {
      heldDuration += dt;
      if (heldDuration >= 4.0) {
        disarm();
      }
    } else {
      heldDuration = 0;
    }
  }

  void disarm() {
    if (isDisarmed) return;

    isDisarmed = true;
    print("폭탄 해체 성공!");
    removeFromParent();

    // 🎉 Clutch 텍스트 추가
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
          ..position = gameRef.size / 2;

    gameRef.add(clutchText);

    // ✨ 애니메이션: 커졌다 작아지는 + 약간 위로 뜨는 효과
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
      MoveByEffect(Vector2(0, -30), EffectController(duration: 1.2)),
    ]);

    // ⏳ 2.5초 후 메인 메뉴로 이동
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
