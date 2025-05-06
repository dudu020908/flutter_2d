import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'background.dart';
import 'bomb.dart';
import 'gameworld.dart';
import 'player.dart';

class MyPlatformerGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  // ------튜토리얼 모드-------
  final bool isTutorial;
  final VoidCallback? onTutorialDisarm;

  MyPlatformerGame({this.isTutorial = false, this.onTutorialDisarm});
  //-------------------------

  late final Player _player;
  late final GameWorld _gameWorld;
  JoystickComponent? _joystick;
  late final Background _background;
  late Bomb bomb; // 나중에 할당받음
  Set<LogicalKeyboardKey> keysPressed = {};

  @override
  Future<void> onLoad() async {
    super.onLoad();

    camera.viewport = FixedResolutionViewport(resolution: Vector2(1920, 1080));

    _player = Player();
    _gameWorld = GameWorld(
      player: _player,
      isTutorial: isTutorial,
      onTutorialDisarm: onTutorialDisarm,
    );

    world = _gameWorld;
    camera.world = world;

    await add(world);

    _background = Background();
    await add(_background);

    camera.follow(_player, horizontalOnly: false);

    await _gameWorld.ready; // GameWorld 내부 bomb 생성 기다리기
    // 튜토리얼 모드면 onTutorialDisarm 콜백만 등록
    bomb = Bomb(
      _gameWorld.bomb!.position,
      onTutorialDisarm: isTutorial ? onTutorialDisarm : null,
    );
    add(bomb);

    // 모바일 조이스틱 추가
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      _joystick = JoystickComponent(
        knob: CircleComponent(
          radius: 15,
          paint: Paint()..color = const Color(0xFFFFFFFF),
          priority: 2,
        ),
        background: CircleComponent(
          radius: 60,
          paint: Paint()..color = const Color(0x88000000),
        ),
        margin: const EdgeInsets.only(left: 50, bottom: 700),
      );
      add(_joystick!);
      _player.joystick = _joystick!;
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    this.keysPressed = keysPressed;
    _player.handleKeyEvent(event, keysPressed);
    return KeyEventResult.handled;
  }

  Player get player => _player;
}
