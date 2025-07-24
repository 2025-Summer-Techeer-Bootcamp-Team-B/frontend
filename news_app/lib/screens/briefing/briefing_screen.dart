import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'bri_playlist.dart';
import 'bri_caption.dart'; // Added import for BriCaptionScreen
import 'bri_chatbot.dart'; // BriChatBotScreen import 추가

class BriefingScreen extends StatefulWidget {
  const BriefingScreen({super.key});

  @override
  State<BriefingScreen> createState() => _BriefingScreenState();
}

class _BriefingScreenState extends State<BriefingScreen>
    with TickerProviderStateMixin {
  // Article data state
  String articleTitle = '기사 제목';
  String articleSource = '기사 출처';
  String articleImageUrl = 'assets/a_image/burn_airplane.png';
  bool shouldAnimate = false;
  late AnimationController _titleAnimationController;
  late Animation<Offset> _titleAnimation;

  // Audio progress state
  double audioProgress = 0.0; // 0% to 100%
  String currentTime = '0:00';
  String totalTime = '0:00';
  bool isPlaying = false;
  late Timer _audioTimer;
  int _currentSeconds = 0;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();

    // Initialize title animation
    _titleAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _titleAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-0.3, 0),
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.linear,
    ));

    // Mock API call - replace with real API integration
    _fetchArticleData();

    // Initialize audio timer
    _audioTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isPlaying) {
        _updateAudioProgress();
      }
    });
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    _audioTimer.cancel();
    super.dispose();
  }

  // Mock API call - replace with real API integration
  Future<void> _fetchArticleData() async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - replace with actual API call
      // TODO: Replace with real API endpoint
      final mockApiResponse = {
        'title': "'역대급 실적' SK하이닉스, 상반기 성과급 '150%' 지급",
        'source': "연합뉴스",
        'imageUrl': 'assets/a_image/SKhynix',
        'audioDuration': 123, // 2:03 in seconds
      };

      setState(() {
        articleTitle = mockApiResponse['title'] as String;
        articleSource = mockApiResponse['source'] as String;
        articleImageUrl = mockApiResponse['imageUrl'] as String;
        _totalSeconds = mockApiResponse['audioDuration'] as int;
        totalTime = _formatTime(_totalSeconds);
      });

      // Check if title needs scrolling animation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkTitleAnimation();
      });
    } catch (error) {
      print('기사 데이터를 불러오는 중 오류가 발생했습니다: $error');
      // Keep default title on error
    }
  }

  void _checkTitleAnimation() {
    // 글자 수가 9자 초과일 때 애니메이션 적용
    if (articleTitle.length > 9) {
      setState(() {
        shouldAnimate = true;
      });
      _titleAnimationController.repeat();
    }
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      // Start playing
      print('재생 시작');
    } else {
      // Pause playing
      print('일시정지');
    }
  }

  void _updateAudioProgress() {
    if (_currentSeconds < _totalSeconds) {
      setState(() {
        _currentSeconds++;
        audioProgress = _currentSeconds / _totalSeconds;
        currentTime = _formatTime(_currentSeconds);
      });
    } else {
      // Audio finished
      setState(() {
        isPlaying = false;
        _currentSeconds = 0;
        audioProgress = 0.0;
        currentTime = _formatTime(0);
      });
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _skipToPrevious() {
    setState(() {
      _currentSeconds = max(0, _currentSeconds - 10);
      audioProgress = _currentSeconds / _totalSeconds;
      currentTime = _formatTime(_currentSeconds);
    });
  }

  void _skipToNext() {
    setState(() {
      _currentSeconds = min(_totalSeconds, _currentSeconds + 10);
      audioProgress = _currentSeconds / _totalSeconds;
      currentTime = _formatTime(_currentSeconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // width: 393,
        // height: 852,
        // 검은 테두리 제거
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black),
        // ),
        child: Stack(
          children: [
            // Main Content - Fixed layout for iPhone 15
            Column(
              children: [
                // Date Header
                const Padding(
                  padding: EdgeInsets.only(top: 64, bottom: 16),
                  child: Text(
                    '2025년 7월 7일',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Main Article Image - Smaller square shape
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 카테고리명
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0565FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '경제',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 기존 이미지
                      Expanded(
                        child: Container(
                          width: 320,
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/a_image/SKhynix.jpg',
                              fit: BoxFit.cover,
                              width: 320,
                              height: 280,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 이미지 아래에 제목+출처+아이콘 Row 추가 (뮤직앱 스타일)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 제목+출처
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              articleTitle,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Pretendard',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              articleSource,
                              style: const TextStyle(
                                color: Color(0xFF0565FF),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 아이콘
                      Row(
                        children: [
                          Image.asset(
                            'assets/a_image/star.png',
                            width: 28,
                            height: 28,
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BriChatBotScreen(),
                                ),
                              );
                            },
                            child: Image.asset(
                              'assets/a_image/chatbot.webp',
                              width: 36,
                              height: 36,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16), // Reduced spacing

                // Audio Progress - Animated like music app
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currentTime, // Dynamic current time
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            totalTime, // Dynamic total time
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6), // Reduced spacing
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 6, // Slightly smaller
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: MediaQuery.of(context).size.width *
                                audioProgress *
                                0.84, // 0.84 = (393-56)/393
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFF555555),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16), // Reduced spacing

                // Audio Controls - Custom styled like the image
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Previous Button - Two overlapping left triangles
                    GestureDetector(
                      onTap: _skipToPrevious,
                      child: SizedBox(
                        width: 45,
                        height: 45,
                        child: CustomPaint(
                          painter: RewindIconPainter(),
                        ),
                      ),
                    ),

                    const SizedBox(width: 48), // Reduced spacing

                    // Pause/Play Button - Two vertical lines for pause, triangle for play
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: SizedBox(
                        width: 44, // Slightly smaller
                        height: 44,
                        child: isPlaying
                            ? CustomPaint(
                                painter: PauseIconPainter(),
                              )
                            : CustomPaint(
                                painter: PlayIconPainter(),
                              ),
                      ),
                    ),

                    const SizedBox(width: 48), // Reduced spacing

                    // Next Button - Two overlapping right triangles
                    GestureDetector(
                      onTap: _skipToNext,
                      child: SizedBox(
                        width: 45,
                        height: 45,
                        child: CustomPaint(
                          painter: FastForwardIconPainter(),
                        ),
                      ),
                    ),
                  ],
                ),

                // Flexible space to push bottom navigation down
                const Spacer(),
              ],
            ),

            // Category Tag - Positioned in Stack
            Positioned(
              left: 14, // 12에서 14로 변경 (오른쪽으로 2픽셀 이동)
              top: 96,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 9), // 패딩을 살짝 키움
                decoration: BoxDecoration(
                  color: const Color(0xFF0565FF),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Text(
                  '경제',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // 16에서 18로 키움
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ),

            // Bottom Navigation using assets
            Positioned(
              bottom: 40, // 20에서 40으로 올려서 버튼을 위로 이동
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // List Music Icon from assets
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const BriPlaylistScreen(),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/a_image/list-music.png',
                        width: 28,
                        height: 28,
                      ),
                    ),
                    // Caption Icon from assets
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BriCaptionScreen(
                              imageUrl: articleImageUrl,
                              title: articleTitle,
                              reporter: articleSource,
                              category: '경제',
                              scriptLines: const [
                                'SK하이닉스는 올해 상반기에',
                                '구성원들에게 월 기본급의',
                                "150%를 '생산성 격려금'으로",
                                '지급할 예정이다.',
                                '',
                                '이는 고대역폭 메모리 시장 1위를',
                                '차지하며 역대급 실적을 달성한 결과이다.',
                                '',
                                'PI는 영업이익률에 따라 지급되며,',
                                'SK하이닉스는 1분기에 42%의',
                                '영업이익률을 기록했다.',
                                '',
                                '2분기 실적은 매출 20조',
                                '6천164억 원,',
                                '영업이익 9조 222억 원으로 예상되며,',
                                '하반기에도 높은 실적이 예상되어',
                                '성과급이 상승할 것으로 전망된다.',
                                '',
                                '증권가는 SK하이닉스의 연간',
                                '영업이익이 37조 원에 달할 것으로',
                                '예상하고 있다.',
                              ],
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/a_image/caption.png',
                        width: 28,
                        height: 28,
                      ),
                    ),
                    // Newspaper Icon with text from assets
                    Column(
                      children: [
                        Image.asset(
                          'assets/a_image/newspaper.png',
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(height: 6), // Reduced spacing
                        const Text(
                          '기사 원문보기',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Slightly smaller
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painters for the audio control icons - More rounded and spaced triangles
class RewindIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1D1E1E)
      ..style = PaintingStyle.fill;

    // First triangle (back) - More spaced
    final path1 = Path();
    path1.moveTo(size.width * 0.75, size.height * 0.2);
    path1.lineTo(size.width * 0.75, size.height * 0.8);
    path1.lineTo(size.width * 0.35, size.height * 0.5);
    path1.close();
    canvas.drawPath(path1, paint);

    // Second triangle (front) - More spaced
    final path2 = Path();
    path2.moveTo(size.width * 0.65, size.height * 0.2);
    path2.lineTo(size.width * 0.65, size.height * 0.8);
    path2.lineTo(size.width * 0.25, size.height * 0.5);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PauseIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1D1E1E)
      ..style = PaintingStyle.fill;

    // First vertical line - More rounded
    final rect1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.25, size.height * 0.2, size.width * 0.15,
          size.height * 0.6),
      const Radius.circular(3),
    );
    canvas.drawRRect(rect1, paint);

    // Second vertical line - More rounded
    final rect2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.6, size.height * 0.2, size.width * 0.15,
          size.height * 0.6),
      const Radius.circular(3),
    );
    canvas.drawRRect(rect2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PlayIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1D1E1E)
      ..style = PaintingStyle.fill;

    // Play triangle - More rounded corners
    final path = Path();
    path.moveTo(size.width * 0.25, size.height * 0.2);
    path.lineTo(size.width * 0.25, size.height * 0.8);
    path.lineTo(size.width * 0.75, size.height * 0.5);
    path.close();

    // Create rounded triangle effect
    final roundedPath = Path();
    final points = [
      Offset(size.width * 0.25, size.height * 0.2),
      Offset(size.width * 0.25, size.height * 0.8),
      Offset(size.width * 0.75, size.height * 0.5),
    ];

    // Draw rounded triangle
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FastForwardIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1D1E1E)
      ..style = PaintingStyle.fill;

    // First triangle (back) - More spaced
    final path1 = Path();
    path1.moveTo(size.width * 0.25, size.height * 0.2);
    path1.lineTo(size.width * 0.25, size.height * 0.8);
    path1.lineTo(size.width * 0.65, size.height * 0.5);
    path1.close();
    canvas.drawPath(path1, paint);

    // Second triangle (front) - More spaced
    final path2 = Path();
    path2.moveTo(size.width * 0.35, size.height * 0.2);
    path2.lineTo(size.width * 0.35, size.height * 0.8);
    path2.lineTo(size.width * 0.75, size.height * 0.5);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
