// 플레이어 클래스: 캐릭터의 움직임, 중력, 점프, 충돌 등을 담당
import 'package:flame/collisions.dart'; // 충돌 감지를 위한 패키지
import 'package:flame/components.dart'; // Flame의 기본 컴포넌트
import 'package:flutter/services.dart'; // 키보드 입력 감지용
import 'game.dart';
import 'obstacle.dart';
import 'platform.dart';
import 'bomb.dart';

class Player extends SpriteComponent
    with HasGameRef<MyPlatformerGame>, CollisionCallbacks {
  // 중력, 점프 힘, 이동 속도 정의
  static const double gravity = 600;
  static const double jumpForce = -400;
  static const double speed = 200;

  // 속도 및 상태 변수
  double velocityY = 0; // y축 속도
  double velocityX = 0; // x축 속도
  bool isOnGround = false; // 바닥에 있는지 여부
  double fKeyHeldTime = 0.0; // F키 누른 시간

  Vector2 moveDirection = Vector2.zero(); // 이동 방향 벡터
  late Vector2 initialPosition;
  JoystickComponent? _joystick; // 조이스틱 컴포넌트

  // 외부에서 조이스틱을 주입받는 setter
  set joystick(JoystickComponent joystick) {
    _joystick = joystick;
  }

  // 생성자: 시작 위치 지정 가능
  Player({Vector2? position}) {
    this.position = position ?? Vector2(100, 300);
  }

  // 컴포넌트가 로드될 때 실행됨
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player2.png'); // 플레이어 이미지 불러오기
    size = Vector2.all(gameRef.size.x * 0.08); // // 크기 설정
    anchor = Anchor.center; // 중심 기준으로 위치 지정
    add(RectangleHitbox()); // 사각형 히트박스 추가
  }

  // 점프 함수: 바닥에 있을 때만 점프 가능
  void jump() {
    if (isOnGround) {
      velocityY = jumpForce;
      isOnGround = false;
    }
  }

  // 매 프레임마다 실행되는 업데이트 함수
  @override
  void update(double dt) {
    super.update(dt);

    // 조이스틱 입력이 있다면 방향 갱신
    if (_joystick != null) {
      moveDirection = _joystick!.relativeDelta;
    }

    // 중력 적용 및 속도 계산
    velocityY += gravity * dt;
    velocityX = moveDirection.x * speed;

    // 위치 이동
    position.y += velocityY * dt;
    position.x += velocityX * dt;

    // 화면 경계 제한 처리
    final screenWidth = gameRef.size.x;
    final screenHeight = gameRef.size.y;
    if (position.x < 0) position.x = 0; // 왼쪽 벗어남 방지

    // 바닥에 닿았을 때 처리
    if (position.y + size.y / 2 >= screenHeight) {
      position = initialPosition.clone(); // 처음 위치로 이동
      velocityY = 0;
      isOnGround = true;
    }

    // F 키 누르고 있는 시간 누적
    if (gameRef.keysPressed.contains(LogicalKeyboardKey.keyF)) {
      fKeyHeldTime += dt;
      if (fKeyHeldTime >= 4.0 && gameRef.bomb != null) {
        gameRef.bomb!.disarm(); // 폭탄 해제
      }
    } else {
      fKeyHeldTime = 0.0;
    }
  }

  // 충돌이 발생했을 때 호출됨
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Platform && velocityY > 0) {
      final bottom = position.y + size.y / 2;
      final platformTop = other.position.y - (other.size.y / 2);
      final correction = bottom - platformTop;
      position.y -= correction; //위치 보정
      velocityY = 0;
      isOnGround = true;
    }

    if (other is Obstacle) {
      position = initialPosition.clone();
      velocityY = 0;
      isOnGround = true;
    }
  }

  // 키보드 입력 처리 (PC용)
  void handleKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
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
