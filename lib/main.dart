import 'package:flutter/material.dart';
import 'logo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Platformer Game',
      debugShowCheckedModeBanner: false,
      home: const LogoScreen(),
    );
  }
}
