import 'package:flutter/material.dart';
import 'logo_screen.dart'; // 로고 화면으로 이동

class IntroGifScreen extends StatefulWidget {
  const IntroGifScreen({super.key});

  @override
  State<IntroGifScreen> createState() => _IntroGifScreenState();
}

class _IntroGifScreenState extends State<IntroGifScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // 3초 후 로고 화면으로 이동
    Future.delayed(const Duration(seconds: 3), _goToLogoScreen);
  }

  void _goToLogoScreen() {
    if (_navigated) return;
    _navigated = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LogoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goToLogoScreen, // 유저가 탭하면 바로 넘기기
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/intro.gif'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
