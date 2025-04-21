import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dart:ui';

class Obstacle extends PositionComponent with CollisionCallbacks {
  Obstacle(Vector2 position, Vector2 size) {
    this.position = position;
    this.size = size;
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), Paint()..color = const Color(0xFFFF0000));
  }
}
