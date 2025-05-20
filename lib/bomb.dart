import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'main_menu_screen.dart';

class Bomb extends PositionComponent with HasGameRef<MyPlatformerGame> {
  double heldDuration = 0;
  bool isDisarmed = false;
  final VoidCallback? onTutorialDisarm;
  late SpriteComponent bombSprite;
  late BombTimerText timerText;

  Bomb(Vector2 position, {this.onTutorialDisarm}) {
    this.position = position;
    size = Vector2(30, 30);
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    try {
      final sprite = await gameRef.loadSprite('bomb.png');
      final characterSize = gameRef.size.x * 0.08;
      final bombSize = characterSize;
      bombSprite = SpriteComponent(
        sprite: sprite,
        size: Vector2(bombSize, bombSize * 1.2),
        anchor: Anchor.bottomCenter,
      );

      add(bombSprite);

      // ⏲️ 타이머 UI 생성 및 추가
      timerText = BombTimerText(remaining: 60);
      await gameRef.add(timerText);

      // ⏱️ 제한 시간 타이머 컴포넌트
      await gameRef.add(
        TimerComponent(
          period: 60,
          removeOnFinish: true,
          onTick: onTimerExpired,
        ),
      );
    } catch (e) {
      print('❌ bomb sprite load failed: $e');
    }

    add(RectangleHitbox());
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

  Future<void> disarm() async {
    if (isDisarmed) return;
    isDisarmed = true;
    removeFromParent();
    timerText.removeFromParent(); // ✅ UI 제거

    print('💥 Bomb.disarm() 호출됨 — CLUTCH 추가');

    final clutchText = ClutchText(Vector2(0, -120));
    await gameRef.add(clutchText);

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
      RemoveEffect(delay: 1.6),
    ]);

    if (onTutorialDisarm != null) {
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

  void onTimerExpired() {
    if (isDisarmed) return;

    timerText.removeFromParent(); // ✅ 시간 초과 시 UI 제거
    print('⏰ 제한시간 초과 - 폭탄 폭발!');

    final boomText =
        TextComponent(
            text: 'GameOver!',
            textRenderer: TextPaint(
              style: const TextStyle(
                fontSize: 60,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
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
          ..position = gameRef.size / 2 + Vector2(0, -180)
          ..priority = 200;

    gameRef.add(boomText);

    gameRef.add(
      TimerComponent(
        period: 2,
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

class BombTimerText extends TextComponent with HasGameRef<MyPlatformerGame> {
  double remaining;
  late TextComponent textComp;
  BombTimerText({required this.remaining});

  @override
  Future<void> onLoad() async {
    position = Vector2(gameRef.size.x / 2, 20);
    anchor = Anchor.topCenter;
    priority = 999;

    textComp = TextComponent(
      text: 'Time: ${remaining.toInt()}',
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(blurRadius: 4, color: Colors.black)],
        ),
      ),
    );

    await add(textComp);
  }

  @override
  void update(double dt) {
    super.update(dt);
    remaining -= dt;
    if (remaining < 0) remaining = 0;
    textComp.text = 'Time: ${remaining.toInt()}';
    // 고정 위치 재설정 (카메라 무시)
    position = Vector2(gameRef.size.x / 2, 20);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // 해상도 변경 시 위치 재설정
    position = Vector2(size.x / 2, 20);
  }
}

class ClutchText extends TextComponent with HasGameRef<MyPlatformerGame> {
  final Vector2 offset;

  ClutchText(this.offset)
    : super(
        text: 'CLUTCH!',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 60,
            color: Colors.redAccent,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(blurRadius: 10, color: Colors.black, offset: Offset(3, 3)),
            ],
          ),
        ),
      ) {
    anchor = Anchor.center;
    priority = 100;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = size / 2 + offset;
  }
}
