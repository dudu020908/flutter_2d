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
  late DisarmGauge disarmGauge;

  Bomb(Vector2 position, {this.onTutorialDisarm}) {
    this.position = position;
    size = Vector2(30, 30);
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    try {
      final sprite = await gameRef.loadSprite('bomb_1.png');
      final characterSize = gameRef.size.x * 0.08;
      final bombSize = characterSize;
      bombSprite = SpriteComponent(
        sprite: sprite,
        size: Vector2(bombSize, bombSize * 1.2),
        anchor: Anchor.bottomCenter,
      );

      add(bombSprite);

      timerText = BombTimerText(remaining: 60);
      await gameRef.add(timerText);

      disarmGauge = DisarmGauge();
      await gameRef.add(disarmGauge);

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

      // 게이지 보이게 + 진행도 계산
      disarmGauge
        ..visible = true
        ..progress = (heldDuration / 4.0).clamp(0.0, 1.0);

      if (heldDuration > 4.0) heldDuration = 4.0;

      final progress = (heldDuration / 4.0).clamp(0.0, 1.0);
      final frame = (progress * 7).floor(); // 0~7 → bomb_1~bomb_8

      // 프레임에 맞는 스프라이트 교체
      gameRef.loadSprite('bomb_${frame + 1}.png').then((sprite) {
        bombSprite.sprite = sprite;
      });

      if (heldDuration >= 4.0) {
        disarmGauge.visible = false;
        disarm();
      }
    } else {
      // 해제 취소 상태
      heldDuration = 0;
      disarmGauge
        ..visible = false
        ..progress = 0.0;

      gameRef.loadSprite('bomb_1.png').then((sprite) {
        bombSprite.sprite = sprite;
      });
    }
  }

  Future<void> disarm() async {
    if (isDisarmed) return;
    isDisarmed = true;

    removeFromParent();
    timerText.removeFromParent();
    disarmGauge.removeFromParent();

    gameRef.player.canMove = false;
    await gameRef.player.jumpToBomb(position);
    await Future.delayed(const Duration(milliseconds: 300));

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

    timerText.removeFromParent();
    disarmGauge.removeFromParent();
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
    position = Vector2(gameRef.size.x / 2, 20);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(size.x / 2, 20);
  }
}

class DisarmGauge extends PositionComponent with HasGameRef<MyPlatformerGame> {
  double progress = 0.0;
  bool visible = false;

  @override
  void render(Canvas canvas) {
    if (!visible) return; // ❗이걸 꼭 넣어줘야 평소에 안 보임

    super.render(canvas);

    final gaugeWidth = gameRef.size.x * 0.5;
    final gaugeHeight = 10.0;

    final bgRect = Rect.fromLTWH(
      (gameRef.size.x - gaugeWidth) / 2,
      50,
      gaugeWidth,
      gaugeHeight,
    );

    final fgRect = Rect.fromLTWH(
      (gameRef.size.x - gaugeWidth) / 2,
      50,
      gaugeWidth * progress,
      gaugeHeight,
    );

    final bgPaint = Paint()..color = Colors.grey.shade700;
    final fgPaint = Paint()..color = Colors.greenAccent;

    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(5)),
      bgPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(fgRect, const Radius.circular(5)),
      fgPaint,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
  }

  @override
  int get priority => 999;
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
