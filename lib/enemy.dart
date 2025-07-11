import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<FlameGame> {
  final Vector2 initialPosition;
  final double baseSpeed;
  double speed;

  /// Enemy가 왔다 갔다 할 X 범위
  final double minX;
  final double maxX;
  double _dir = 1;

  late final Sprite _rightSprite;
  late final Sprite _leftSprite;

  Enemy({
    required Vector2 position,
    required Vector2 baseSize,
    required this.minX,
    required this.maxX,
    double initialSpeed = 100,
  }) : initialPosition = position.clone(), baseSpeed = initialSpeed, speed = initialSpeed,
       super(position: position, size: baseSize * 2, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _rightSprite = await gameRef.loadSprite('enemy_1.png');
    _leftSprite = await gameRef.loadSprite('enemy_2.png');

    sprite = _rightSprite;

    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // 좌우 왕복
    position.x += speed * dt * _dir;

    sprite = (_dir > 0) ? _rightSprite : _leftSprite;

    // 경계에 닿으면 방향 반전
    if (position.x - size.x / 2 <= minX) {
      position.x = minX + size.x / 2;
      _dir = 1;
    } else if (position.x + size.x / 2 >= maxX) {
      position.x = maxX - size.x / 2;
      _dir = -1;
    }
  }
}
