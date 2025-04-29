import 'package:flame/components.dart';

import 'platform.dart';

class MovingPlatform extends Platform {
  final Vector2 moveBy;
  final double speed;
  double _time = 0.0;
  Vector2 _lastPosition = Vector2.zero();
  Vector2 delta = Vector2.zero(); // 🔥 이번 프레임 이동량

  MovingPlatform(
    Vector2 position,
    Vector2 size, {
    required this.moveBy,
    required this.speed,
  }) : super(position, size) {
    _lastPosition = position.clone();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    // 이동
    position += moveBy * speed * dt;

    // 이동량 계산
    delta = position - _lastPosition;
    _lastPosition = position.clone();

    // 왕복 이동
    if (_time > 2.0) {
      _time = 0.0;
      moveBy.negate();
    }
  }
}
