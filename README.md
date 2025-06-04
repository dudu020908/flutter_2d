# 진격의 윙맨

진격의 윙맨은 Flutter와 Flame 엔진을 사용해서 만든 간단한 2D 플랫포머 게임입니다.  
장애물을 피해 제한시간 내에 스파이크를 해체하면 승리합니다.
조작은 키보드 혹은은 모바일 터치로 조작 가능합니다.

# 주요 기능

- Flame 엔진 기반 2D 플랫폼 게임
- 키보드 및 모바일 터치 지원
- 튜토리얼 모드
- 제한 시간 내 스파이크 해체 미션
- 앱, 웹 플랫폼 동시 지원
- 발로란트 게임의 캐릭터와 진격의 거인을 모티브해 흥미를 이끔

# 구성 파일

- 'main.dart' :
- 'main_menu_screen.dart' : 메인 메뉴 화면
- 'game_screen.dart' : 실제 게임이 진행되는 화면
- 'game.dart' : Flame 기반 게임 로직
- 'gameworld.dart' : 월드 내 오브젝트들 구성
- 'player.dart' : 플레이어 캐릭터
- 'bomb.dart' : 폭탄, 해체 로직 포함
- 'result_screen.dart' : 게임 결과 화면
- 'tutorial_screen.dart' : 튜토리얼 모드
- 'enemy.dart', 'enemy_platform.dart' : 장애물물 및 움직이는 발판
- 'obstacle.dart' : 장애물
- 'background.dart' : 배경 이미지
- 'config.dart' : 기본 설정값
- 'intro_gif.dart', 'logo_screen.dart' : 인트로 및 로고

# 조작법

- ← / → 방향키: 좌우 이동
- 스페이스바: 점프
- F키 또는 모바일 ↓ 버튼: 폭탄 해체 시도

# 실행 방법

1. 프로젝트 클론하는 법법:

git clone https://github.com/dudu020908/flutter_2d
