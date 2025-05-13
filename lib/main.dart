import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_platformer_game/intro_gif.dart';
// import 'package:my_platformer_game/intro_video.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Platformer Game',
      debugShowCheckedModeBanner: false,
      home: IntroGifScreen(),
    );
  }
}
