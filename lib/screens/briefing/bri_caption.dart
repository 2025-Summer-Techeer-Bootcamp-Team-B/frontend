import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:news_app/screens/briefing/bri_playlist.dart'; // Added import for BriPlaylistScreen

class BriCaptionScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String reporter;
  final String category;
  final List<String> scriptLines;

  const BriCaptionScreen({
    required this.imageUrl,
    required this.title,
    required this.reporter,
    this.category = '경제',
    this.scriptLines = const [
      'SK하이닉스는 올해 상반기에 구성원들에게',
      "월 기본급의 150%를 '생산성 격려금'으로 지급할 예정이다.",
      '',
      '이는 고대역폭 메모리 시장 1위를 차지하며',
      '역대급 실적을 달성한 결과이다.',
      '',
      'PI는 영업이익률에 따라 지급되며,',
      'SK하이닉스는 1분기에 42%의 영업이익률을 기록했다.',
      '',
      '2분기 실적은 매출 20조 6천164억 원,',
      '영업이익 9조 222억 원으로 예상되며,',
      '하반기에도 높은 실적이 예상되어',
      '성과급이 상승할 것으로 전망된다.',
      '',
      '증권가는 SK하이닉스의 연간 영업이익이',
      '37조 원에 달할 것으로 예상하고 있다.',
    ],
    Key? key,
  }) : super(key: key);

  @override
  State<BriCaptionScreen> createState() => _BriCaptionScreenState();
}

class _BriCaptionScreenState extends State<BriCaptionScreen>
    with TickerProviderStateMixin {
  int currentLine = 0;
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  // Audio player
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  bool hasUserInteracted = false; // 사용자 상호작용 확인

  // 각 줄별 재생 시간 (초 단위) - 실제 음성에 맞게 조정 필요
  final List<double> lineTimings = [0, 3, 6, 9, 12, 15, 18];

  // Title animation
  bool shouldAnimate = false;
  late AnimationController _titleAnimationController;
  late Animation<Offset> _titleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize audio player
    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();

    // Initialize title animation
    _titleAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _titleAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-1, 0),
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.linear,
    ));

    _checkTitleAnimation();
  }

  void _setupAudioPlayer() async {
    try {
      // 음성 파일 로드 - 크롬 호환성을 위해 설정 추가
      await _audioPlayer.setSource(AssetSource('a_voice/SK_tts.mp3'));

      // 크롬에서의 오디오 재생을 위한 설정
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      // 재생 상태 리스너
      _audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      });

      // 재생 시간 리스너
      _audioPlayer.onPositionChanged.listen((position) {
        setState(() {
          currentPosition = position;
          _updateCurrentLine(position);
        });
      });

      // 전체 재생 시간 리스너
      _audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          totalDuration = duration;
        });
      });

      // 재생 완료 리스너
      _audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          isPlaying = false;
          currentLine = 0;
        });
      });
    } catch (e) {
      print('오디오 설정 오류: $e');
      // 오디오 로드 실패 시 타이머로 자막 진행
      _startFallbackTimer();
    }
  }

  void _startFallbackTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentLine < widget.scriptLines.length - 1) {
        setState(() {
          currentLine++;
        });
        _scrollToCurrentLine();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _startAutoPlay() async {
    if (!hasUserInteracted) {
      hasUserInteracted = true;
      try {
        await _audioPlayer.resume();
      } catch (e) {
        print('자동 재생 오류: $e');
      }
    }
  }

  void _updateCurrentLine(Duration position) {
    final currentSeconds = position.inSeconds;

    // 현재 시간에 맞는 줄 찾기
    for (int i = 0; i < lineTimings.length; i++) {
      if (currentSeconds >= lineTimings[i] &&
          (i == lineTimings.length - 1 ||
              currentSeconds < lineTimings[i + 1])) {
        if (currentLine != i) {
          setState(() {
            currentLine = i;
          });
          _scrollToCurrentLine();
        }
        break;
      }
    }
  }

  void _checkTitleAnimation() {
    setState(() {
      shouldAnimate = true;
    });
    _titleAnimationController.repeat();
  }

  void _scrollToCurrentLine() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 읽는 줄이 화면 중앙(혹은 1/3)쯤에 오도록 offset 계산
      const itemHeight = 48.0;
      const containerHeight = 852 - 200; // 대략 상단 UI 제외한 높이
      final centerOffset = (currentLine * itemHeight) - (containerHeight / 3);

      // 화면에서 안보이면 자동으로 스크롤
      if (centerOffset > _scrollController.offset) {
        _scrollController.animateTo(
          centerOffset > 0 ? centerOffset : 0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    _titleAnimationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 아이폰 15 사이즈 기준 레이아웃
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 393,
            height: 852,
            color: Colors.white,
            child: Column(
              children: [
                // 상단 바 (클릭하면 자동 재생 시작)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          _startAutoPlay(); // 사용자 상호작용으로 자동 재생 시작
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                // 기사 정보
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 대표 이미지 (왼쪽)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/a_image/SKhynix.jpg',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20),
                      // 카테고리명 추가
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0565FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          widget.category,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 타이틀 (오른쪽, 사진에 겹치지 않게)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRect(
                              child: shouldAnimate
                                  ? SlideTransition(
                                      position: _titleAnimation,
                                      child: Text(
                                        widget.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Arial',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.visible,
                                      ),
                                    )
                                  : Text(
                                      widget.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Arial',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.reporter,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Arial',
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ...아이콘, 별 아이콘(assets)
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.more_horiz,
                                    color: Colors.grey),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 2),
                              IconButton(
                                icon: Image.asset(
                                  'assets/a_image/star.png',
                                  width: 28,
                                  height: 28,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                // 대본(스크롤) - 클릭하면 자동 재생 시작
                Expanded(
                  child: GestureDetector(
                    onTap: _startAutoPlay, // 화면 터치로 자동 재생 시작
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      itemCount: widget.scriptLines.length,
                      itemBuilder: (context, idx) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            widget.scriptLines[idx],
                            textAlign: TextAlign.center, // 가운데 정렬
                            style: TextStyle(
                              fontSize: 22, // 글자 크기 줄임
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Arial', // 기본 폰트로 변경
                              color: idx == currentLine
                                  ? Colors.black
                                  : Colors.black38,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // 하단 3개 버튼 (브리핑과 동일)
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 24, left: 32, right: 32), // 40에서 24로 변경
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 리스트 버튼
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image.asset(
                          'assets/a_image/list-music.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                      // CC 버튼 (리스트로 이동)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const BriPlaylistScreen(),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/a_image/caption.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                      // 기사 원문보기 버튼
                      Column(
                        children: [
                          Image.asset(
                            'assets/a_image/newspaper.png',
                            width: 28,
                            height: 28,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '기사 원문보기',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
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
