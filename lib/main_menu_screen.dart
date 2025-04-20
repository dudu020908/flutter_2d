import 'package:flutter/material.dart';
import 'game_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  double _scaleGame = 1.0;
  double _scaleSettings = 1.0;

  void _onHover(bool hovering, String type) {
    setState(() {
      if (type == 'game') {
        _scaleGame = hovering ? 1.1 : 1.0;
      } else if (type == 'settings') {
        _scaleSettings = hovering ? 1.1 : 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          SizedBox.expand(
            child: Image.asset('assets/images/MainMenu.png', fit: BoxFit.cover),
          ),

          // 중앙 텍스트 버튼
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 게임 시작 텍스트
                MouseRegion(
                  onEnter: (_) => _onHover(true, 'game'),
                  onExit: (_) => _onHover(false, 'game'),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const GameScreen()),
                      );
                    },
                    child: AnimatedScale(
                      scale: _scaleGame,
                      duration: const Duration(milliseconds: 200),
                      child: const Text(
                        '게임 시작',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 설정 텍스트
                MouseRegion(
                  onEnter: (_) => _onHover(true, 'settings'),
                  onExit: (_) => _onHover(false, 'settings'),
                  child: GestureDetector(
                    onTap: () {
                      // 설정 기능 예정
                    },
                    child: AnimatedScale(
                      scale: _scaleSettings,
                      duration: const Duration(milliseconds: 200),
                      child: const Text(
                        '설정',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
