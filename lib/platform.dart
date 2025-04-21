import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dart:ui';

class Platform extends PositionComponent with CollisionCallbacks {
  Platform(Vector2 position, Vector2 size) {
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
    canvas.drawRect(size.toRect(), Paint()..color = const Color(0xFF00FF00)); // 초록색으로 플랫폼 렌더링
  }
}
