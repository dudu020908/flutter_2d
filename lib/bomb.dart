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
      add(RectangleHitbox());

      timerText = BombTimerText(remaining: 60);
      await gameRef.add(timerText);

      await gameRef.add(
        TimerComponent(
          period: 60,
          removeOnFinish: true,
          onTick: onTimerExpired,
        ),
      );
    } catch (e, stack) {
      print('❌ bomb sprite load failed: $e\n$stack');
    }
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

  Future<void> disarm() async {
    if (isDisarmed) return;
    isDisarmed = true;
    removeFromParent();
    timerText.removeFromParent();

    final clutchText = FloatingText(
      content: 'CLUTCH!',
      color: Colors.redAccent,
      offset: Vector2(0, -120),
    );
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

    timerText.removeFromParent();

    final boomText = FloatingText(
      content: 'GameOver!',
      color: Colors.orange,
      offset: Vector2(0, -120),
    );
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

class BombTimerText extends TextComponent {
  double remaining;

  BombTimerText({required this.remaining})
    : super(
        anchor: Anchor.topCenter,
        position: Vector2(0, 20), // 화면 상단 중앙에 고정
        priority: 999,
        text: '',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(blurRadius: 4, color: Colors.black)],
          ),
        ),
      );

  @override
  void update(double dt) {
    super.update(dt);
    remaining -= dt;
    if (remaining < 0) remaining = 0;
    text = 'Time: ${remaining.toInt()}';
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(size.x / 2, 20); // 항상 상단 중앙
  }
}

class FloatingText extends TextComponent with HasGameRef<MyPlatformerGame> {
  final String content;
  final Color color;
  final Vector2 offset;

  FloatingText({
    required this.content,
    required this.color,
    required this.offset,
  }) : super(
         text: content,
         anchor: Anchor.center,
         priority: 200,
         textRenderer: TextPaint(
           style: TextStyle(
             fontSize: 60,
             color: color,
             fontWeight: FontWeight.bold,
             shadows: const [
               Shadow(
                 blurRadius: 10,
                 color: Colors.black,
                 offset: Offset(3, 3),
               ),
             ],
           ),
         ),
       );

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = size / 2 + offset;
  }
}
