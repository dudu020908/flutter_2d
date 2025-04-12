import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game.dart'; // 너가 만든 FlameGame 클래스

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GameWidget(game: MyPlatformerGame()));
  }
}
