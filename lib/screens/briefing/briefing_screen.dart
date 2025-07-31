import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:dio/dio.dart';
import '../../models/article_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';
import 'bri_playlist.dart';
import 'bri_caption.dart';
import 'bri_chatbot.dart';
import 'bri_article_text.dart';
import 'package:provider/provider.dart';
import '../../providers/tts_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/history_provider.dart';
import '../../services/api_service.dart';

class BriefingScreen extends StatefulWidget {
  final ArticleModel? article;
  final bool autoPlay;
  const BriefingScreen({super.key, this.article, this.autoPlay = false});

  @override
  State<BriefingScreen> createState() => _BriefingScreenState();
}

class _BriefingScreenState extends State<BriefingScreen>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool _isReady = false;
  String? _audioUrl;
  Map<String, dynamic>? _articleData;

  // Article data state
  String articleTitle = '';
  String articleSource = '';
  String articleImageUrl = '';
  bool shouldAnimate = false;
  late AnimationController _titleAnimationController;
  late Animation<Offset> _titleAnimation;



  Future<void> _fetchAndSetAudio() async {
    final articleId = widget.article?.id;
    if (articleId == null) return;
    print('기사 ID: $articleId');
    try {
      // ApiService 인스턴스 사용
      final apiService = ApiService();
      // ApiService가 초기화되어 있지 않으면 초기화
      await apiService.initialize();
      final response = await apiService.get('/api/v1/articles/$articleId');
      final data = response.data;
      print('API 응답: $data');
      setState(() {
        _articleData = data;
        articleTitle = data['title'] ?? '';
        articleSource = data['author'] ?? '';
        articleImageUrl = data['thumbnail_image_url'] ?? '';
      });
      final url = data['female_audio_url'];
      _audioUrl = url;
      if (url != null && url.isNotEmpty) {
        final duration = await _audioPlayer.setUrl(url);
        print('setUrl 완료, duration: $duration');
        setState(() {
          _isReady = true;
        });
        // autoPlay가 true면 오디오 준비 후 바로 재생
        if (widget.autoPlay) {
          final ttsProvider = Provider.of<TtsProvider>(context, listen: false);
          if (widget.article != null) {
            ttsProvider.play(widget.article!, audioPlayer: _audioPlayer);
          }
          await _audioPlayer.play();
          
          // 재생 기록에 추가
          if (widget.article != null) {
            final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
            historyProvider.addToHistory(widget.article!);
          }
        }
        // TtsProvider에 오디오 플레이어 등록 (자동 재생 방지)
        final ttsProvider = Provider.of<TtsProvider>(context, listen: false);
        if (widget.article != null) {
          // 현재 기사가 이미 재생 중인지 확인
          if (ttsProvider.isPlaying && ttsProvider.currentArticle?.id == widget.article!.id) {
            // 이미 재생 중인 기사라면 아무것도 하지 않음 (백그라운드 재생 유지)
            print('이미 재생 중인 기사:  [${widget.article!.title} (백그라운드 재생 유지)');
            // 오디오 플레이어 설정하지 않음
          } else {
            // 새 기사이거나 재생 중이 아닌 경우
            if (!ttsProvider.isPlaying) {
              ttsProvider.setArticle(widget.article!, audioPlayer: _audioPlayer);
            }
          }
        }
        // 오디오 설정 완료 후 상태 동기화
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _syncAudioPlayerState();
        });
      } else {
        print('오디오 URL이 비어있음');
      }
      // Check if title needs scrolling animation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkTitleAnimation();
      });
    } catch (e) {
      print('오디오 API 에러: $e');
    }
  }

  void _checkTitleAnimation() {
    // 글자 수가 15자 초과일 때 애니메이션 적용 (더 긴 제목에서만)
    if (articleTitle.length > 15) {
      setState(() {
        shouldAnimate = true;
      });
      _titleAnimationController.forward(); // 한 번만 실행
    } else {
      setState(() {
        shouldAnimate = false;
      });
      _titleAnimationController.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _fetchAndSetAudio();

    // Initialize title animation
    _titleAnimationController = AnimationController(
      duration: const Duration(seconds: 20), // 더 천천히 움직이도록 조정
      vsync: this,
    );

    _titleAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-3.0, 0), // 텍스트가 완전히 지나가도록 더 많이 움직임
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.linear, // 선형 움직임으로 변경
    ));

    // 한 번만 실행하되 긴 거리를 움직이도록
    _titleAnimationController.forward();

    // 현재 기사가 이미 재생 중인지 확인하고 동기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncAudioPlayerState();
      _checkTitleAnimation();
    });
  }

  void _syncAudioPlayerState() {
    final ttsProvider = Provider.of<TtsProvider>(context, listen: false);
    
    // 현재 기사가 TtsProvider에서 재생 중인지 확인 (자동 재생 방지)
    if (widget.article != null && 
        ttsProvider.isPlaying && 
        ttsProvider.currentArticle?.id == widget.article!.id) {
      // 이미 재생 중인 기사라면 자동 재생하지 않고 상태만 확인
      print('기존 재생 상태 확인: ${widget.article!.title} (자동 재생 안함)');
      // 백그라운드에서 재생 중이므로 현재 오디오 플레이어는 정지 상태로 유지
      if (_audioPlayer.playing) {
        _audioPlayer.pause();
      }
    } else {
      // 재생 중이 아니라면 오디오 플레이어도 정지 상태로 설정
      if (_audioPlayer.playing) {
        _audioPlayer.pause();
      }
    }
  }

  void _togglePlayPause() async {
    if (!_isReady) return;
    
    final ttsProvider = Provider.of<TtsProvider>(context, listen: false);
    
    // 현재 재생 상태를 확인해서 토글
    final playing = _audioPlayer.playing;
    if (playing) {
      // 일시정지
      await _audioPlayer.pause();
      ttsProvider.pause();
      print('일시정지');
    } else {
      // 재생 시작 - 다른 기사가 재생 중이면 자동으로 정지됨
      if (widget.article != null) {
        ttsProvider.play(widget.article!, audioPlayer: _audioPlayer);
      }
      await _audioPlayer.play();
      print('재생 시작');
      
      // 재생 기록에 추가
      if (widget.article != null) {
        final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
        historyProvider.addToHistory(widget.article!);
      }
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _skipToPrevious() async {
    if (!_isReady) return;
    final currentPosition = await _audioPlayer.position;
    final newPosition = currentPosition.inMilliseconds > 10000 
        ? currentPosition - const Duration(seconds: 10)
        : Duration.zero;
    await _audioPlayer.seek(newPosition);
  }

  void _skipToNext() async {
    if (!_isReady) return;
    final currentPosition = await _audioPlayer.position;
    final duration = await _audioPlayer.duration;
    if (duration != null) {
      final newPosition = currentPosition.inMilliseconds + 10000 < duration.inMilliseconds
          ? currentPosition + const Duration(seconds: 10)
          : duration;
      await _audioPlayer.seek(newPosition);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _titleAnimationController.dispose();
    super.dispose();
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.year}년 ${now.month}월 ${now.day}일';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            // Main Content - Fixed layout for iPhone 15
            Column(
              children: [
                // Date Header
                Padding(
                  padding: const EdgeInsets.only(top: 64, bottom: 16),
                  child: Text(
                    _getCurrentDate(),
                    style: const TextStyle(
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
                    width: 320,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _articleData != null && _articleData!['thumbnail_image_url'] != null && _articleData!['thumbnail_image_url'].isNotEmpty
                          ? Image.network(
                              _articleData!['thumbnail_image_url'],
                              fit: BoxFit.cover,
                              width: 320,
                              height: 280,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 320,
                                height: 280,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.image, size: 60, color: Colors.grey),
                                ),
                              ),
                            )
                          : Container(
                              width: 320,
                              height: 280,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.image, size: 60, color: Colors.grey),
                              ),
                            ),
                    ),
                  ),
                ),
                // 이미지 아래에 제목+출처+아이콘 Row 추가 (뮤직앱 스타일)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 제목+출처 - 버튼과 겹치지 않도록 공간 확보
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 제목만 애니메이션 적용 - 버튼과 겹치지 않도록 제한
                          Container(
                            height: 32, // 한 줄 높이로 제한
                            width: MediaQuery.of(context).size.width * 0.35, // 화면 너비의 35%만 사용 (더 좁게)
                            child: shouldAnimate
                                ? SlideTransition(
                                    position: _titleAnimation,
                                    child: Text(
                                      '$articleTitle  $articleTitle', // 텍스트를 두 번 반복
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Pretendard',
                                      ),
                                      maxLines: 1, // 한 줄로 제한
                                      overflow: TextOverflow.visible, // 넘치는 텍스트도 보이도록
                                      softWrap: false, // 줄바꿈 방지
                                    ),
                                  )
                                : Text(
                                    articleTitle,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Pretendard',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                          const SizedBox(height: 10), // 기자 이름을 아래로 내림
                          // 출처는 애니메이션 없이 고정
                          Text(
                            articleSource,
                            style: const TextStyle(
                              color: Color(0xFF0565FF),
                              fontSize: 20,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(), // 남은 공간을 모두 사용하여 아이콘을 오른쪽으로 밀어냄
                      // 액션 버튼들
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 50), // 버튼들을 아래로 내림
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 즐겨찾기 버튼 (왼쪽으로 이동)
                              Consumer<FavoritesProvider>(
                                builder: (context, favoritesProvider, child) {
                                  final isFavorite = favoritesProvider.isFavorite(widget.article?.id ?? '');
                                  return GestureDetector(
                                    onTap: () {
                                      if (widget.article != null) {
                                        favoritesProvider.toggleFavorite(widget.article!);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isFavorite ? '즐겨찾기에서 제거되었습니다.' : '즐겨찾기에 추가되었습니다.'
                                            ),
                                            backgroundColor: const Color(0xFF0565FF),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: isFavorite ? const Color(0xFF0565FF) : Colors.white,
                                        borderRadius: BorderRadius.circular(22),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorite ? Colors.white : Colors.red,
                                        size: 22,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              // 챗봇 버튼 (오른쪽으로 이동)
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BriChatBotScreen(
                                        articleId: widget.article?.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: Image.asset(
                                      'assets/a_image/chatbot.webp',
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4), // Reduced spacing

                // Audio Progress - Animated like music app
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      StreamBuilder<Duration?>(
                        stream: _audioPlayer.durationStream,
                        builder: (context, durationSnapshot) {
                          final duration = durationSnapshot.data ?? Duration.zero;
                          return StreamBuilder<Duration>(
                            stream: _audioPlayer.positionStream,
                            builder: (context, positionSnapshot) {
                              final position = positionSnapshot.data ?? Duration.zero;
                              
                              String formatDuration(Duration d) {
                                String twoDigits(int n) => n.toString().padLeft(2, '0');
                                return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}';
                              }
                              
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatDuration(position),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        formatDuration(duration),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD9D9D9),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 100),
                                        width: duration.inMilliseconds > 0
                                            ? MediaQuery.of(context).size.width *
                                                (position.inMilliseconds / duration.inMilliseconds) *
                                                0.84
                                            : 0,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF555555),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30), // Increased spacing from 8 to 16

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
                        child: Consumer<TtsProvider>(
                          builder: (context, ttsProvider, child) {
                            // 현재 기사가 재생 중인지 확인
                            final isCurrentArticlePlaying = widget.article != null && 
                                ttsProvider.isPlaying && 
                                ttsProvider.currentArticle?.id == widget.article!.id;
                            
                            return isCurrentArticlePlaying
                                ? CustomPaint(
                                    painter: PauseIconPainter(),
                                  )
                                : CustomPaint(
                                    painter: PlayIconPainter(),
                                  );
                          },
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

                const SizedBox(height: 20), // Added extra spacing below controls

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
                    horizontal: 20, vertical: 7), // 패딩을 줄임
                decoration: BoxDecoration(
                  color: const Color(0xFF0565FF),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  _articleData?['category_name'] ?? '경제',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20, // 14에서 16으로 키움
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ),

            // Bottom Navigation using assets
            Positioned(
              bottom: 56, // 기존 40에서 20으로 줄여 살짝 위로 올림
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
                        final summaryRaw = _articleData?['summary_text'];
                        List<String> scriptLines;
                        if (summaryRaw is String && summaryRaw.isNotEmpty) {
                          scriptLines = summaryRaw
                              .replaceAll('\n', ' ')
                              .split(RegExp(r'(?<=[.!?])\s+'))
                              .map((e) => e.trim())
                              .where((line) => line.isNotEmpty)
                              .toList();
                        } else {
                          scriptLines = ['요약이 없습니다.'];
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BriCaptionScreen(
                              imageUrl: articleImageUrl,
                              title: articleTitle,
                              reporter: articleSource,
                              scriptLines: scriptLines,
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
                    // Newspaper Icon from assets
                    GestureDetector(
                      onTap: () {
                        final articleUrl = _articleData?['url'];
                        if (articleUrl != null && articleUrl.isNotEmpty) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BriArticleTextScreen(
                                title: articleTitle,
                                url: articleUrl,
                              ),
                            ),
                          );
                        } else {
                          // URL이 없는 경우 스낵바로 알림
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('기사 원문을 불러올 수 없습니다.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Image.asset(
                        'assets/a_image/newspaper.png',
                        width: 28,
                        height: 28,
                      ),
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
