import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'game.dart';

const double keyWidth = 90;
const double keyHeight = 68;

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MyPlatformerGame game = MyPlatformerGame();
    return Scaffold(
      body: Stack(
        children: [
          // 1) 게임 월드
          GameWidget(game: game),

          // 2) 점프 버튼 (앱 실행 전용)
          if (!kIsWeb)
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () => game.player.jump(),
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

          // 3) 방향키 패드 (앱 전용)
          if (!kIsWeb)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Table(
                  defaultColumnWidth: const FixedColumnWidth(keyWidth),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    // 첫째 행: [빈칸, ↑ 해체, 빈칸]
                    TableRow(
                      children: [
                        const SizedBox(),
                        GestureDetector(
                          onTapDown: (_) => game.isHoldingBomb = true,
                          onTapUp: (_) => game.isHoldingBomb = false,
                          onTapCancel: () => game.isHoldingBomb = false,
                          child: _keyCap(Icons.keyboard_arrow_up),
                        ),
                        const SizedBox(),
                      ],
                    ),
                    // 둘째 행: [←, ↓, →]
                    TableRow(
                      children: [
                        GestureDetector(
                          onTapDown: (_) => game.player.moveDirection.x = -1,
                          onTapUp: (_) => game.player.moveDirection.x = 0,
                          onTapCancel: () => game.player.moveDirection.x = 0,
                          child: _keyCap(Icons.keyboard_arrow_left),
                        ),
                        GestureDetector(
                          onTapDown: (_) {
                            /* duck 로직 등 */
                          },
                          onTapUp: (_) => {},
                          onTapCancel: () => {},
                          child: _keyCap(Icons.keyboard_arrow_down),
                        ),
                        GestureDetector(
                          onTapDown: (_) => game.player.moveDirection.x = 1,
                          onTapUp: (_) => game.player.moveDirection.x = 0,
                          onTapCancel: () => game.player.moveDirection.x = 0,
                          child: _keyCap(Icons.keyboard_arrow_right),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 사각 테두리 키캡 스타일
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
}
