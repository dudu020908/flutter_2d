import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'background.dart'; // 배경 컴포넌트
import 'gameworld.dart';
import 'player.dart';

class MyPlatformerGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late final Player _player;
  late final GameWorld _gameWorld;
  JoystickComponent? _joystick;
  late final Background _background; // 배경 변수 추가

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 화면 크기에 맞는 뷰포트 설정
    camera.viewport = FixedResolutionViewport(resolution: Vector2(1920, 1080));

    // 플레이어와 게임 월드 설정
    _player = Player();
    _gameWorld = GameWorld(player: _player);

    world = _gameWorld;
    camera.world = world;

    // 게임 월드와 배경을 추가
    await add(world);

    // 배경을 게임에 추가
    _background = Background();
    await add(_background);

    // 카메라가 플레이어를 따라감
    camera.follow(_player, horizontalOnly: false); // 수평, 수직 모두 따라가도록 설정

    // 모바일 환경일 경우 조이스틱 추가
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      _joystick = JoystickComponent(
        knob: CircleComponent(
          radius: 15, // 크기 증가
          paint: Paint()..color = const Color(0xFFFFFFFF),
          priority: 2,
        ),
        background: CircleComponent(
          radius: 60, // 크기 증가
          paint: Paint()..color = const Color(0x88000000),
        ),
        margin: const EdgeInsets.only(left: 50, bottom: 700), // 화면 좌측 하단에 위치
      );
      print("Adding joystick...");
      add(_joystick!); // 조이스틱을 추가
      _player.joystick = _joystick!; // 플레이어에 조이스틱 연결
      print("Joystick added");
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    _player.handleKeyEvent(event, keysPressed);
    return KeyEventResult.handled;
  }
}
