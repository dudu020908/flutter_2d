// 📁 background.dart
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Background extends SpriteComponent with HasGameRef<FlameGame> {
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('background2.png');
    anchor = Anchor.center;
    position = gameRef.size / 2;
    _resizeToFitScreen();
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    position = canvasSize / 2;
    super.onGameResize(canvasSize);
    _resizeToFitScreen();
  }

  void _resizeToFitScreen([Vector2? actualSize]) {
    if (sprite == null) return;

    final screenSize = actualSize ?? gameRef.size;
    final imageSize = sprite!.srcSize;

    // 가로/세로 비율 기준으로 스케일 계산 (더 큰 쪽 기준으로 확대)
    final scaleX = screenSize.x / imageSize.x;
    final scaleY = screenSize.y / imageSize.y;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    size = imageSize * scale;
  }
}
