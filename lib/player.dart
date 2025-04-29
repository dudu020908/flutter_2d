// 플레이어 클래스: 캐릭터의 움직임, 중력, 점프, 충돌 등을 담당
import 'package:flame/collisions.dart'; // 충돌 감지를 위한 패키지
import 'package:flame/components.dart'; // Flame의 기본 컴포넌트
import 'package:flutter/services.dart'; // 키보드 입력 감지용

import 'game.dart';
import 'moving_platform.dart';
import 'obstacle.dart';
import 'platform.dart';
import 'vanishing_platform.dart';

class Player extends SpriteComponent
    with HasGameRef<MyPlatformerGame>, CollisionCallbacks {
  // 중력, 점프 힘, 이동 속도 정의
  static const double gravity = 600;
  static const double jumpForce = -400;
  static const double speed = 300;

  // 속도 및 상태 변수
  double velocityY = 0;
  double velocityX = 0;
  bool isOnGround = false;
  double fKeyHeldTime = 0.0;

  Vector2 moveDirection = Vector2.zero();
  late Vector2 initialPosition;
  JoystickComponent? _joystick;
  int tutorialMoves = 0;

  Platform? currentPlatform; // 현재 밟고 있는 발판

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

    // 움직이는 발판 위에 있다면 함께 이동
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

    if (gameRef.keysPressed.contains(LogicalKeyboardKey.keyF)) {
      if (gameRef.bomb != null &&
          (position - gameRef.bomb!.position).length < 50) {
        fKeyHeldTime += dt;
        if (fKeyHeldTime >= 4.0) {
          gameRef.bomb!.disarm();
          fKeyHeldTime = 0.0;
        }
      }
    } else {
      fKeyHeldTime = 0.0;
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

      currentPlatform = other; // 현재 발판 저장

      if (other is VanishingPlatform) {
        other.onPlayerTouch();
      }
    }

    if (other is Obstacle) {
      position = initialPosition.clone();
      velocityY = 0;
      isOnGround = true;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other == currentPlatform) {
      currentPlatform = null;
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
