// tutorial_screenn.dart
import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:my_platformer_game/game.dart';

import 'main_menu_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  bool _showIntro = true;
  bool _showMoveInstr = false;
  bool _showPerfect = false;
  bool _showHomeButton = false;
  double _homeScale = 1.0;
  late final MyPlatformerGame _game;
  Timer? _moveCheckTimer;

  @override
  void initState() {
    super.initState();
    _game = MyPlatformerGame();

    // 2초 뒤 1단계 숨기고 2단계 표시
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _showIntro = false;
        _showMoveInstr = true;
      });
      // 2단계가 켜지고 나면 플레이어 움직임 카운트 체크 시작
      _startMoveCheck();
    });
  }

  void _startMoveCheck() {
    _moveCheckTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_game.player.tutorialMoves >= 3) {
        t.cancel();
        _onPerfect();
      }
    });
  }

  void _onPerfect() {
    setState(() {
      _showMoveInstr = false;
      _showPerfect = true; // Perfect!! 표시
    });
    // 3초 뒤 Perfect 숨기고 홈 버튼 표시
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _showPerfect = false;
        _showHomeButton = true;
      });
    });
  }

  @override
  void dispose() {
    _moveCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 높이 10% 지점
    final double guideTop = MediaQuery.of(context).size.height * 0.1;

    return Scaffold(
      body: Stack(
        children: [
          // ────────────────────────────────────────────────
          // ① 실제 튜토리얼 환경: 게임 월드 + 플레이
          GameWidget(game: _game),

          // ────────────────────────────────────────────────
          // ② 1단계: '튜토리얼을 시작합니다' (상단 중앙)
          if (_showIntro)
            Positioned(
              top: guideTop,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '튜토리얼을 시작합니다',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          // ────────────────────────────────────────────────
          // ③ 2단계: '좌우로 3회 움직이기' (상단 중앙)
          else if (_showMoveInstr)
            Positioned(
              top: guideTop,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '좌우로 3회 움직이기',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          // ────────────────────────────────────────────────
          // ④ 완료: 'Perfect!!'
          else if (_showPerfect)
            Positioned(
              top: guideTop,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Perfect!!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          // ────────────────────────────────────────────────
          // ⑤ 완료 후 홈 버튼 (좌측 상단)
          if (_showHomeButton)
            Positioned(
              top: 16,
              left: 16,
              child: MouseRegion(
                onEnter: (_) => setState(() => _homeScale = 0.9), // 호버 시 축소
                onExit: (_) => setState(() => _homeScale = 1.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainMenuScreen()),
                    );
                  },
                  child: AnimatedScale(
                    scale: _homeScale, // 호버 스케일 반영
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          'H',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
