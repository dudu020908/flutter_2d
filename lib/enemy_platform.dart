import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'platform.dart';

class EnemyPlatform extends Platform {
  static final Vector2 _fixedSize = Vector2(400, 40);
  final Vector2 enemyBaseSize;

  EnemyPlatform(Vector2 position, {required this.enemyBaseSize})
    : super(position, _fixedSize);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite.sprite = await gameRef.loadSprite('platform.png');

    // 2) 충돌용 히트박스
    add(RectangleHitbox(size: size, collisionType: CollisionType.passive));
  }
}
