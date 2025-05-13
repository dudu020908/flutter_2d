// tutorial_screen.dart
import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:my_platformer_game/game.dart';

import 'main_menu_screen.dart';

const double keyWidth = 90;
const double keyHeight = 68;

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
    _game = MyPlatformerGame(
      isTutorial: true,
      onTutorialDisarm: () {
        setState(() {
          _showBombInstr = false;
          _showHomeButton = true;
        });
      },
    );

    // ① 2초 뒤 이동+점프 안내
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
        final moveText = kIsWeb ? '좌우 3회 움직이기 → 점프' : '◀ ▶ 버튼 3회 터치 → 점프 버튼';
        tutorialStep = _msg(guideTop, moveText, Colors.black54);
      } else if (_showPerfect) {
        tutorialStep = _msg(
          guideTop,
          'Perfect!!',
          Colors.green.withOpacity(0.8),
        );
      } else if (_showBombInstr) {
        final bombText = kIsWeb ? 'F키로 폭탄 해체' : '↑ 버튼으로 폭탄 해체';
        tutorialStep = _msg(guideTop, bombText, Colors.black54);
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // 1) 게임 월드
          GameWidget(game: _game),

          // 2) 튜토리얼 메시지
          if (tutorialStep != null) tutorialStep,

          // 3) 추락 메시지
          if (_showFallMsg)
            _msg(guideTop, '맵에서 떨어지면 초기위치로 돌아갑니다', Colors.red.withOpacity(0.8)),

          // 4) 웹 키 가이드
          if (kIsWeb && !_showHomeButton && !_showIntro)
            Positioned(top: 16, right: 16, child: _keyGuide()),

          // 5) 점프 버튼 (앱 전용)
          if (!kIsWeb)
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  _game.player.jump();
                  _game.player.tutorialJumps++;
                },
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

          // 6) 컨트롤 패드 전체 묶음 (앱 전용)
          if (!kIsWeb)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Table(
                  defaultColumnWidth: const FixedColumnWidth(keyWidth),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    // 위 방향키
                    TableRow(
                      children: [
                        const SizedBox(),
                        GestureDetector(
                          onTapDown: (_) => _game.isHoldingBomb = true,
                          onTapUp: (_) => _game.isHoldingBomb = false,
                          onTapCancel: () => _game.isHoldingBomb = false,
                          child: _keyCap(Icons.keyboard_arrow_up),
                        ),
                        const SizedBox(),
                      ],
                    ),
                    // 왼쪽,아래,오른쪽 방향키
                    TableRow(
                      children: [
                        GestureDetector(
                          onTapDown: (_) {
                            _game.player.moveDirection.x = -1;
                            _game.player.tutorialMoves++;
                          },
                          onTapUp: (_) => _game.player.moveDirection.x = 0,
                          onTapCancel: () => _game.player.moveDirection.x = 0,
                          child: _keyCap(Icons.keyboard_arrow_left),
                        ),
                        GestureDetector(
                          onTapDown: (_) {
                            /* duck 로직 */
                          },
                          onTapUp: (_) => {},
                          onTapCancel: () => {},
                          child: _keyCap(Icons.keyboard_arrow_down),
                        ),
                        GestureDetector(
                          onTapDown: (_) {
                            _game.player.moveDirection.x = 1;
                            _game.player.tutorialMoves++;
                          },
                          onTapUp: (_) => _game.player.moveDirection.x = 0,
                          onTapCancel: () => _game.player.moveDirection.x = 0,
                          child: _keyCap(Icons.keyboard_arrow_right),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // 7) 홈 버튼 (튜토리얼 완료 후)
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
          // ▲ End Tutorial UI
        ],
      ),
    );
  }

  /// 공통 컨트롤 버튼 스타일
  Widget _keyCap(IconData icon) {
    return Container(
      width: keyWidth,
      height: keyHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black26,
        border: Border.all(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, size: keyHeight * 0.5, color: Colors.white),
    );
  }

  /// 메시지 박스 헬퍼
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

  /// 웹용 키 가이드
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
