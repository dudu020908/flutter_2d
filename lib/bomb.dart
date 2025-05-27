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

      disarmGauge
        ..visible = true
        ..progress = (heldDuration / 4.0).clamp(0.0, 1.0);

      if (heldDuration > 4.0) heldDuration = 4.0;

      final progress = (heldDuration / 4.0).clamp(0.0, 1.0);
      final frame = (progress * 7).floor();

      gameRef.loadSprite('bomb_${frame + 1}.png').then((sprite) {
        bombSprite.sprite = sprite;
      });

      if (heldDuration >= 4.0) {
        disarmGauge.visible = false;
        disarm();
      }
    } else {
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

// ✅ Timer 텍스트
class BombTimerText extends TextComponent with HasGameRef<MyPlatformerGame> {
  double remaining;

  BombTimerText({required this.remaining})
    : super(
        text: 'Time: ${remaining.toInt()}',
        anchor: Anchor.topCenter,
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
  Future<void> onLoad() async {
    position = Vector2(gameRef.size.x / 2, 20);
    priority = 999;
  }

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
    position = Vector2(size.x / 2, 20);
  }
}

// ✅ 해체 게이지
class DisarmGauge extends Component with HasGameRef<MyPlatformerGame> {
  double progress = 0.0;
  bool visible = false;

  late Rect bgRect;
  late Rect fgRect;
  final double gaugeHeight = 10.0;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final gaugeWidth = size.x * 0.5;
    final left = (size.x - gaugeWidth) / 2;
    bgRect = Rect.fromLTWH(left, 50, gaugeWidth, gaugeHeight);
    fgRect = Rect.fromLTWH(left, 50, gaugeWidth * progress, gaugeHeight);
  }

  @override
  void render(Canvas canvas) {
    if (!visible) return;

    // 업데이트된 전경 길이
    final fgWidth = bgRect.width * progress;
    fgRect = Rect.fromLTWH(bgRect.left, bgRect.top, fgWidth, gaugeHeight);

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
  int get priority => 999;
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
  Future<void> onLoad() async {
    position = gameRef.size / 2 + offset;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = size / 2 + offset;
  }
}
