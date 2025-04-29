// 플레이어 클래스: 캐릭터의 움직임, 중력, 점프, 충돌 등을 담당
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'bomb.dart';
import 'game.dart';
import 'moving_platform.dart';
import 'obstacle.dart';
import 'platform.dart';
import 'vanishing_platform.dart';

class Player extends SpriteComponent
    with HasGameRef<MyPlatformerGame>, CollisionCallbacks {
  static const double gravity = 600;
  static const double jumpForce = -400;
  static const double speed = 1000;

  double velocityY = 0;
  double velocityX = 0;
  bool isOnGround = false;
  double fKeyHeldTime = 0.0;

  Vector2 moveDirection = Vector2.zero();
  late Vector2 initialPosition;
  JoystickComponent? _joystick;
  int tutorialMoves = 0;

  Platform? currentPlatform;
  Bomb? touchingBomb;

  set joystick(JoystickComponent joystick) {
    _joystick = joystick;
  }

  Player({Vector2? position}) {
    this.position = position ?? Vector2(100, 300);
  }

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player2.png');
    size = Vector2.all(gameRef.size.x * 0.08);
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  void jump() {
    if (isOnGround) {
      velocityY = jumpForce;
      isOnGround = false;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (currentPlatform is MovingPlatform) {
      final delta = (currentPlatform as MovingPlatform).delta;
      position += delta;
    }

    if (_joystick != null) {
      moveDirection = _joystick!.relativeDelta;
    }

    velocityY += gravity * dt;
    velocityX = moveDirection.x * speed;
    position.y += velocityY * dt;
    position.x += velocityX * dt;

    final screenWidth = gameRef.size.x;
    final screenHeight = gameRef.size.y;
    if (position.x < 0) position.x = 0;

    if (position.y + size.y / 2 >= screenHeight) {
      position = initialPosition.clone();
      velocityY = 0;
      isOnGround = true;
    }

    // 🔥 F키 해체 로직
    if (gameRef.keysPressed.contains(LogicalKeyboardKey.keyF)) {
      if (touchingBomb != null) {
        touchingBomb!.updateHolding(true, dt);
      }
    } else {
      gameRef.bomb.updateHolding(false, dt);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Platform && velocityY > 0) {
      final bottom = position.y + size.y / 2;
      final platformTop = other.position.y - (other.size.y / 2);
      final correction = bottom - platformTop;
      position.y -= correction;
      velocityY = 0;
      isOnGround = true;

      currentPlatform = other;
      if (other is VanishingPlatform) {
        other.onPlayerTouch();
      }
    }

    if (other is Obstacle) {
      position = initialPosition.clone();
      velocityY = 0;
      isOnGround = true;
    }

    if (other is Bomb) {
      touchingBomb = other;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other == currentPlatform) {
      currentPlatform = null;
    }

    if (other is Bomb && other == touchingBomb) {
      touchingBomb = null;
    }
  }

  void handleKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowRight) {
        tutorialMoves += 1;
        print('🎓 tutorialMoves = \$tutorialMoves');
      }

      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        moveDirection.x = -1;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        moveDirection.x = 1;
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        jump();
      }
    } else if (event is KeyUpEvent) {
      if ((event.logicalKey == LogicalKeyboardKey.arrowLeft &&
              moveDirection.x == -1) ||
          (event.logicalKey == LogicalKeyboardKey.arrowRight &&
              moveDirection.x == 1)) {
        moveDirection.x = 0;
      }
    }
  }
}
