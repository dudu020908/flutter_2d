//game.dart
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'background.dart';
import 'bomb.dart';
import 'gameworld.dart';
import 'player.dart';

class MyPlatformerGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  // ------튜토리얼 모드------
  final bool isTutorial;
  final VoidCallback? onTutorialDisarm;

  MyPlatformerGame({this.isTutorial = false, this.onTutorialDisarm});
  //-------------------------

  late final Player _player;
  late final GameWorld _gameWorld;
  late final Background _background;
  Bomb? bomb;
  Set<LogicalKeyboardKey> keysPressed = {};

  bool isHoldingBomb = false;

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

  @override
  void update(double dt) {
    super.update(dt);

    // 키보드 F키 또는 터치 버튼
    final holding =
        isHoldingBomb || keysPressed.contains(LogicalKeyboardKey.keyF);
    // 플레이어가 충돌한 bomb (touchingBomb)에만 updateHolding 호출
    if (_player.touchingBomb != null) {
      _player.touchingBomb!.updateHolding(holding, dt);
    }
  }

  Player get player => _player;
}
