import 'package:flutter/material.dart';

import 'config.dart';

class SettingsContent extends StatefulWidget {
  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  double _timer = GameConfig.bombTimerSeconds;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('폭탄 타이머 (초)', style: TextStyle(color: Colors.white)),
        Slider(
          min: 10,
          max: 120,
          divisions: 11,
          value: _timer,
          label: _timer.toInt().toString(),
          onChanged: (value) {
            setState(() {
              _timer = value;
            });
          },
        ),
        Text('${_timer.toInt()}초', style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            GameConfig.updateBombTimer(_timer);
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
          child: const Text('저장'),
        ),
      ],
    );
  }
}
