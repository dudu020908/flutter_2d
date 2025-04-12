import 'package:flame/components.dart';
import 'package:my_platformer_game/game.dart';

class Background extends SpriteComponent with HasGameRef<MyPlatformerGame> {
  @override
  Future<void> onLoad() async {
    // 배경 이미지 로드
    sprite = await gameRef.loadSprite('background.png');

    // sprite가 로드되었는지 확인
    if (sprite != null) {
      // 게임 화면 크기 구하기
      final screenSize = gameRef.size;

      // 배경을 반복적으로 그리기
      final numCols = (screenSize.x / sprite!.srcSize.x).ceil();
      final numRows = (screenSize.y / sprite!.srcSize.y).ceil();

      // 각 타일 위치 설정
      for (int i = 0; i < numCols; i++) {
        for (int j = 0; j < numRows; j++) {
          final tile =
              SpriteComponent()
                ..sprite = sprite
                ..size = Vector2(sprite!.srcSize.x, sprite!.srcSize.y)
                ..position = Vector2(
                  i * sprite!.srcSize.x,
                  j * sprite!.srcSize.y,
                );

          add(tile); // 게임에 타일을 추가
        }
      }
    } else {
      print('Error: Background sprite not loaded.');
    }
  }
}
