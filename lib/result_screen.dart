import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_menu_screen.dart';

class ResultScreen extends StatelessWidget {
  final double clearTime;
  final int attemptCount;
  final bool isGameOver;

  const ResultScreen({
    super.key,
    this.clearTime = 0,
    this.attemptCount = 0,
    this.isGameOver = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isGameOver ? Colors.red[700]! : Colors.blue[700]!;
    final backgroundColorStart =
        isGameOver ? Colors.red[100]! : Colors.blue[100]!;
    final backgroundColorEnd = isGameOver ? Colors.red[50]! : Colors.blue[50]!;

    final titleStyle = GoogleFonts.orbitron(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: borderColor,
      shadows: [
        Shadow(
          offset: const Offset(3, 3),
          color: Colors.black54,
          blurRadius: 0,
        ),
      ],
      letterSpacing: 3,
    );

    final textStyle = GoogleFonts.pressStart2p(
      fontSize: 16,
      color: borderColor,
      shadows: [
        Shadow(
          offset: const Offset(1, 1),
          color: Colors.black45,
          blurRadius: 0,
        ),
      ],
    );

    return Scaffold(
      // 베이지톤 그라데이션 배경
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Color(0xFFFAF8F0), Color(0xFFEDE6D9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [backgroundColorStart, backgroundColorEnd],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(color: borderColor, width: 6),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: const Offset(6, 6),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: Colors.white24,
                  offset: const Offset(-4, -4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100,
                  child:
                      isGameOver
                          ? Container(
                            width: 100,
                            height: 100,
                            color: borderColor,
                            child: const Center(
                              child: Text(
                                'X',
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                          : Image.asset(
                            'assets/images/player2.png',
                            height: 100,
                          ),
                ),
                const SizedBox(height: 30),
                Text(
                  isGameOver ? 'MISSION FAILED' : '클러치!',
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                if (!isGameOver)
                  Column(
                    children: [
                      Text(
                        '걸린 시간: ${clearTime.toStringAsFixed(1)}초',
                        style: textStyle,
                      ),
                      const SizedBox(height: 16),
                      Text('죽은 횟수: $attemptCount', style: textStyle),
                    ],
                  ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const MainMenuScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: borderColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black54,
                  ),
                  child: Text(
                    '메인 메뉴',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
