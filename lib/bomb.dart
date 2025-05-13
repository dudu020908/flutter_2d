// bomb.dart
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'main_menu_screen.dart';

class Bomb extends PositionComponent with HasGameRef<MyPlatformerGame> {
  double heldDuration = 0;
  bool isDisarmed = false;

  /// 튜토리얼 모드에서만 사용될 콜백
  final VoidCallback? onTutorialDisarm;

  Bomb(Vector2 position, {this.onTutorialDisarm}) {
    this.position = position;
    size = Vector2(30, 30);
    anchor = Anchor.center;
    add(RectangleHitbox());
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
      print('💣 Bomb.updateHolding: heldDuration=$heldDuration');
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
    removeFromParent();

    print('💥 Bomb.disarm() 호출됨 — CLUTCH 추가');

    // CLUTCH!! 텍스트 효과
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
          ..position = gameRef.size / 2
          ..priority = 100;
    gameRef.add(clutchText);
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

    if (onTutorialDisarm != null) {
      // 튜토리얼 모드: 자동 전환 금지, 콜백만 호출
      onTutorialDisarm!();
    } else {
      gameRef.add(
        TimerComponent(
          period: 2.5,
          removeOnFinish: true,
          onTick: () {
            final ctx = gameRef.buildContext;
            if (ctx != null) {
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: (_) => const MainMenuScreen()),
              );
            }
          },
        ),
      );
    }
  }
}
