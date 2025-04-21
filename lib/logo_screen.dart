import 'dart:async';
import 'package:flutter/material.dart';
import 'main_menu_screen.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  bool _navigated = false;

  void _goToMainMenu() {
    if (_navigated) return;
    _navigated = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainMenuScreen()),
    );
  }

  @override
  void initState() {
    super.initState();

    // 2초 후 자동 이동
    Timer(const Duration(seconds: 2), _goToMainMenu);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goToMainMenu,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Logo.png'), // 로고 이미지
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
