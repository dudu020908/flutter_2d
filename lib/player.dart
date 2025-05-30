import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'bomb.dart';
import 'enemy.dart';
import 'game.dart';
import 'moving_platform.dart';
import 'obstacle.dart';
import 'platform.dart';
import 'vanishing_platform.dart';

class Player extends SpriteAnimationComponent
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

  // 튜토리얼에서 떨어짐 감지용 플래그
  bool justFallen = false;
  int tutorialMoves = 0;
  int tutorialJumps = 0;

  bool canMove = true; // <-- 추가됨 (이동 가능 여부)

  Vector2 get velocity => Vector2(velocityX, velocityY);
  set velocity(Vector2 v) {
    velocityX = v.x;
    velocityY = v.y;
  }

  late SpriteAnimation walkAnimation;
  late SpriteAnimation idleAnimation;

  Platform? currentPlatform;
  Bomb? touchingBomb;

  Player({Vector2? position}) {
    this.position = position ?? Vector2(100, 300);
    initialPosition = this.position.clone();
  }

  Future<void> jumpToBomb(Vector2 bombPosition) async {
    final destination = bombPosition.clone()..y -= 30;

    moveDirection = Vector2.zero();
    velocityX = 0;
    velocityY = 0;

    if (destination.x < position.x) {
      scale.x = -1;
    } else {
      scale.x = 1;
    }

    animation = walkAnimation;

    final move = MoveEffect.to(
      destination,
      EffectController(duration: 0.6, curve: Curves.easeOut),
    );

    await add(move); // 연출 대기
    animation = idleAnimation;
  }

  @override
  Future<void> onLoad() async {
    final spriteSize = Vector2.all(gameRef.size.x * 0.08);

    // 걷기 애니메이션 로드
    walkAnimation = SpriteAnimation.spriteList([
      await gameRef.loadSprite('player3_1.png'),
      await gameRef.loadSprite('player3_2.png'),
      await gameRef.loadSprite('player3_3.png'),
      await gameRef.loadSprite('player3_4.png'),
    ], stepTime: 0.15);

    // 대기 상태 애니메이션 (걷기 첫 프레임 하나만 사용)
    idleAnimation = SpriteAnimation.spriteList([
      await gameRef.loadSprite('player2.png'),
    ], stepTime: 0.15);
    animation = idleAnimation;
    size = spriteSize;
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

    // 애니메이션 상태 변경
    if (moveDirection.x.abs() > 0) {
      animation = walkAnimation;
      if (moveDirection.x < 0) {
        scale.x = -1;
      } else {
        scale.x = 1;
      }
    } else {
      animation = idleAnimation;
    }

    velocityY += gravity * dt;
    velocityX = moveDirection.x * speed;
    position.y += velocityY * dt;
    position.x += velocityX * dt;

    final screenWidth = gameRef.size.x;
    final screenHeight = gameRef.size.y;
    if (position.x < 0) position.x = 0;

    if (position.y + size.y / 2 >= screenHeight) {
      justFallen = true;
      position = initialPosition.clone();
      velocityY = 0;
      isOnGround = true;
    }

    // F키 해제 로직
    if (gameRef.keysPressed.contains(LogicalKeyboardKey.keyF)) {
      if (touchingBomb != null) {
        touchingBomb!.updateHolding(true, dt);
      }
    } else {
      gameRef.bomb?.updateHolding(false, dt);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Platform && velocityY > 0) {
      final bottom = position.y + size.y / 2;
      final platformTop = other.position.y - (other.size.y / 2);
      final isFalling = velocityY > 0;
      final isAbovePlatform = bottom <= platformTop + 10; // 여유 여백

      if (isFalling && isAbovePlatform) {
        // 충돌 인정
        final correction = bottom - platformTop;
        position.y -= correction;
        velocityY = 0;
        isOnGround = true;
        currentPlatform = other;

        if (other is VanishingPlatform) {
          other.onPlayerTouch();
        }
      }
      // 그 외 (옆에서 접근 등): 무시
    }

    if (other is Obstacle) {
      _resetToInitial();
    }

    if (other is Enemy) {
      _resetToInitial();
    }

    if (other is Bomb) {
      touchingBomb = other;
    }
  }

  @override
  void _resetToInitial() {
    position = initialPosition.clone();
    velocityY = 0;
    isOnGround = true;
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
        print('tutorialMoves = $tutorialMoves');
      }
      if (event.logicalKey == LogicalKeyboardKey.space) {
        tutorialJumps += 1;
        print('tutorialJumps = $tutorialJumps');
        jump();
      }

      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        moveDirection.x = -1;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        moveDirection.x = 1;
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
