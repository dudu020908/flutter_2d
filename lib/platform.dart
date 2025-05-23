import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'game.dart';

class Platform extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyPlatformerGame> {
  late SpriteComponent sprite;

  Platform(Vector2 position, Vector2 size) {
    this.position = position;
    this.size = size;
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite =
        SpriteComponent()
          ..sprite = await gameRef.loadSprite('platform.png')
          ..size = Vector2(size.x, size.y)
          ..anchor = Anchor.centerLeft
          ..position = Vector2.zero();

    add(sprite);

    add(
      RectangleHitbox(
        size: size,
        anchor: Anchor.topLeft,
        position: Vector2.zero(), // 중심 기준 하단에 정확히 정렬
        collisionType: CollisionType.passive,
      ),
    );
  }
}
