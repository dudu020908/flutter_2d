import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Obstacle extends SpriteComponent with CollisionCallbacks, HasGameRef {
  Obstacle(Vector2 position, Vector2 size)
    : super(position: position, size: size, anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('obstacle.png');
    add(RectangleHitbox());
  }

  Obstacle clone() {
    return Obstacle(position.clone(), size.clone());
  }
}
