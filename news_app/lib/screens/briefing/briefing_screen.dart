import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'bri_playlist.dart';
import 'bri_caption.dart'; // Added import for BriCaptionScreen

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
      end: const Offset(-1, 0),
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
        'title': "정부, 새로운 정책 발표... 국민들의 관심 집중",
        'source': "연합뉴스",
        'imageUrl': 'assets/a_image/burn_airplane.png',
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
    // In Flutter, we'll use a simpler approach for text overflow detection
    // For now, we'll animate if the title is long
    if (articleTitle.length > 20) {
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
        width: 393,
        height: 852,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
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
                  child: Container(
                    width: 320, // Increased from 280
                    height: 280, // Keep height the same
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        articleImageUrl, // Dynamic image from API
                        fit: BoxFit.cover,
                        width: 320,
                        height: 280,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16), // Reduced spacing

                // Article Title and Meta
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Title with animation - Single line only
                          Expanded(
                            child: shouldAnimate
                                ? SlideTransition(
                                    position: _titleAnimation,
                                    child: Text(
                                      articleTitle, // Dynamic title from API
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22, // Slightly smaller
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Pretendard',
                                      ),
                                      maxLines: 1, // Force single line
                                      overflow: TextOverflow.visible,
                                    ),
                                  )
                                : Text(
                                    articleTitle, // Dynamic title from API
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22, // Slightly smaller
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Pretendard',
                                    ),
                                    maxLines: 1, // Force single line
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                          const SizedBox(width: 12), // Reduced spacing

                          // Icons using assets
                          Row(
                            children: [
                              // Star Icon from assets
                              Image.asset(
                                'assets/a_image/star.png',
                                width: 28,
                                height: 28,
                              ),
                              const SizedBox(width: 8), // Reduced spacing

                              // Chatbot Icon from assets
                              Image.asset(
                                'assets/a_image/chatbot.webp',
                                width: 36,
                                height: 36,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Reduced spacing
                      Text(
                        articleSource, // Dynamic source from API
                        style: const TextStyle(
                          color: Color(0xFF0565FF),
                          fontSize: 16, // Slightly smaller
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
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
              left: 12,
              top: 96,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 6), // Reduced padding
                decoration: BoxDecoration(
                  color: const Color(0xFF0565FF),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Text(
                  '정치',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // Slightly smaller
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ),

            // Bottom Navigation using assets
            Positioned(
              bottom: 20, // Changed from 64 to 20 to move down
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
                              scriptLines: const [
                                "최근 인공지능 기술이 뉴스 소비 방식을 크게 변화시키고 있습니다.",
                                "AI는 사용자의 관심사를 분석해 맞춤형 뉴스를 추천해줍니다.",
                                "음성 합성 기술로 뉴스를 직접 읽어주는 서비스도 등장했습니다.",
                                "이로 인해 시각장애인 등 정보 접근성이 높아졌다는 평가입니다.",
                                "하지만 가짜뉴스 확산 등 부작용에 대한 우려도 커지고 있습니다.",
                                "전문가들은 AI 활용의 긍정적 효과와 함께 윤리적 기준 마련이 필요하다고 강조합니다.",
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
