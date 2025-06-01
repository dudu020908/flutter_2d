import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:my_platformer_game/player.dart';

import 'enemy.dart';
import 'platform.dart';

class EnemyPlatform extends Platform {
  static final Vector2 _fixedSize = Vector2(400, 40);
  final bool isTutorial;
  final Vector2 enemyBaseSize;
  bool _playerOnTop = false;
  Enemy? _enemy;

  EnemyPlatform(Vector2 position, {required this.enemyBaseSize, this.isTutorial = false,})
    : super(position, _fixedSize);

  void attachEnemy(Enemy e) {
    _enemy = e;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite.sprite = await gameRef.loadSprite('platform.png');

    // 2) 충돌용 히트박스
    add(RectangleHitbox(size: size, collisionType: CollisionType.passive));
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);

    if (isTutorial) {
      return;
    }

    if (_enemy == null) {
      return;
    }

    if (other is Player && !_playerOnTop) {
      // 플레이어가 올라탔을 때만 속도 증가
      _playerOnTop = true;
      _enemy!.speed *= 3.5;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (isTutorial) {
      return;
    }

    if (_enemy == null) {
      return;
    }

    if (other is Player && _playerOnTop) {
      // 플레이어가 떠나면 원래 속도로 복원
      _playerOnTop = false;
      _enemy!.speed /= 3.5;
    }
  }
}
