import 'package:flutter/material.dart';
import 'game_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          SizedBox.expand(
            child: Image.asset('assets/images/MainMenu.png', fit: BoxFit.cover),
          ),

          // 버튼 2개 (중앙 정렬)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const GameScreen()),
                    );
                  },
                  child: const Text('게임 시작'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // 설정 기능은 나중에 추가
                  },
                  child: const Text('설정'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
