import 'package:flutter/material.dart';
import 'package:my_platformer_game/settings_screen.dart';

import 'game_screen.dart';
import 'tutorial_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  double _scaleGame = 1.0;
  double _scaleTutorial = 1.0;

  double _scaleSettings = 1.0;

  void _onHover(bool hovering, String type) {
    setState(() {
      if (type == 'game') {
        _scaleGame = hovering ? 1.1 : 1.0;
      } else if (type == 'tutorial') {
        _scaleTutorial = hovering ? 1.1 : 1.0;
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

                // 2) 튜토리얼 가이드 ← 여기에 추가
                MouseRegion(
                  onEnter: (_) => _onHover(true, 'tutorial'),
                  onExit: (_) => _onHover(false, 'tutorial'),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TutorialScreen(),
                        ),
                      );
                    },
                    child: AnimatedScale(
                      scale: _scaleTutorial,
                      duration: const Duration(milliseconds: 200),
                      child: const Text(
                        '튜토리얼 가이드',
                        style: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.w600,
                          color: Colors.lightBlueAccent,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black38,
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
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: const Text(
                                '제한시간 설정',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: SettingsContent(), // 아래에서 따로 구현
                            ),
                      );
                    },
                    child: AnimatedScale(
                      scale: _scaleSettings,
                      duration: const Duration(milliseconds: 200),
                      child: const Text(
                        '설정',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.greenAccent,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black,
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
