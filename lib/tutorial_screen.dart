// tutorial_screen.dart
import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
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
  bool _showBombInstr = false;
  bool _showHomeButton = false;
  bool _showFallMsg = false;

  double _homeScale = 1.0;
  late final MyPlatformerGame _game;
  Timer? _moveTimer, _fallTimer, _bombTimer;

  @override
  void initState() {
    super.initState();
    // 튜토리얼 모드용 Game 인스턴스 (콜백 전달)
    _game = MyPlatformerGame(
      isTutorial: true,
      onTutorialDisarm: () {
        /* 자동 전환 막음 */
        setState(() {
          _showBombInstr = false;
          _showHomeButton = true;
        });
      },
    );

    // ① 2초 뒤 인트로 숨기고 “이동+점프” 단계 시작
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _showIntro = false;
        _showMoveInstr = true;
      });
      _startMoveJumpCheck();
      _startFallCheck();
    });
  }

  void _startMoveJumpCheck() {
    _moveTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_game.player.tutorialMoves >= 3 && _game.player.tutorialMoves >= 1) {
        t.cancel();
        // ② 이동+점프 성공 → “Perfect!!” 2초 보여주고
        setState(() {
          _showMoveInstr = false;
          _showPerfect = true;
        });
        Timer(const Duration(seconds: 2), () {
          setState(() {
            _showPerfect = false;
            _showBombInstr = true;
          });
          _startBombCheck();
        });
      }
    });
  }

  void _startBombCheck() {
    _bombTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_game.bomb?.isDisarmed == true) {
        t.cancel();
        // ③ 폭탄 해체 → H 버튼만 보여주기
        setState(() {
          _showBombInstr = false;
          _showHomeButton = true;
        });
      }
    });
  }

  void _startFallCheck() {
    _fallTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_game.player.justFallen) {
        _game.player.justFallen = false;
        setState(() => _showFallMsg = true);
        Future.delayed(const Duration(seconds: 3), () {
          setState(() => _showFallMsg = false);
        });
      }
    });
  }

  @override
  void dispose() {
    _moveTimer?.cancel();
    _bombTimer?.cancel();
    _fallTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guideTop = MediaQuery.of(context).size.height * 0.1;

    Widget? tutorialStep;
    if (!_showFallMsg) {
      if (_showIntro) {
        tutorialStep = _msg(guideTop, '튜토리얼을 시작합니다', Colors.black54);
      } else if (_showMoveInstr) {
        tutorialStep = _msg(guideTop, '좌우 3회 움직이기 → 점프', Colors.black54);
      } else if (_showPerfect) {
        tutorialStep = _msg(
          guideTop,
          'Perfect!!',
          Colors.green.withOpacity(0.8),
        );
      } else if (_showBombInstr) {
        tutorialStep = _msg(guideTop, 'F키로 폭탄 해체', Colors.black54);
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // 1) 게임 월드
          GameWidget(game: _game),

          // 2) 튜토리얼 단계 메시지
          if (tutorialStep != null) tutorialStep,

          // 3) 추락 시 메시지
          if (_showFallMsg)
            _msg(guideTop, '맵에서 떨어지면 초기위치로 돌아갑니다', Colors.red.withOpacity(0.8)),

          // 4) Web 키 가이드
          if (kIsWeb && !_showHomeButton && !_showIntro)
            Positioned(top: 16, right: 16, child: _keyGuide()),

          // 5) Android 실행시 점프 버튼
          if (!kIsWeb)
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () => _game.player.jump(),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.8),
                  ),
                  child: const Icon(Icons.arrow_upward, color: Colors.white),
                ),
              ),
            ),

          // 6) H 버튼
          if (_showHomeButton)
            Positioned(
              top: 16,
              left: 16,
              child: MouseRegion(
                onEnter: (_) => setState(() => _homeScale = 0.9),
                onExit: (_) => setState(() => _homeScale = 1.0),
                child: GestureDetector(
                  onTap:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainMenuScreen(),
                        ),
                      ),
                  child: AnimatedScale(
                    scale: _homeScale,
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

  // 메시지 박스 헬퍼
  Widget _msg(double top, String text, Color bg) => Positioned(
    top: top,
    left: 0,
    right: 0,
    child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );

  // Web 전용 키 안내 헬퍼
  Widget _keyGuide() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Column(
        children: const [
          Icon(Icons.arrow_left, color: Colors.white),
          Icon(Icons.arrow_right, color: Colors.white),
          SizedBox(height: 4),
          Text('이동', style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
      const SizedBox(width: 16),
      Column(
        children: const [
          Icon(Icons.space_bar, color: Colors.white),
          SizedBox(height: 4),
          Text(
            '점프 (Space)',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
      const SizedBox(width: 16),
      Column(
        children: [
          Text(
            'F',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '해체 (F)',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    ],
  );
}
