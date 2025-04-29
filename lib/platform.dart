import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Platform extends PositionComponent with CollisionCallbacks, HasPaint {
  Platform(Vector2 position, Vector2 size) {
    this.position = position;
    this.size = size;
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    paint = Paint()..color = const Color(0xFF00FF00); // 기본 초록색
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), paint); // 투명도 포함 적용됨
  }
}
