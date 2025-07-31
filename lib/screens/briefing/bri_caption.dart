import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:news_app/screens/briefing/bri_playlist.dart'; // Added import for BriPlaylistScreen
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/tts_provider.dart';
import '../../models/article_models.dart';
import 'bri_article_text.dart';

class BriCaptionScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String reporter;
  final List<String> scriptLines;
  final String? articleId;
  final String? articleUrl;

  const BriCaptionScreen({
    required this.imageUrl,
    required this.title,
    required this.reporter,
    required this.scriptLines,
    this.articleId,
    this.articleUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<BriCaptionScreen> createState() => _BriCaptionScreenState();
}

class _BriCaptionScreenState extends State<BriCaptionScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;
  int currentLine = 0;
  int currentLyricIndex = 0; // 가사 인덱스
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  StreamSubscription? _positionSubscription;

  // Audio player
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  bool hasUserInteracted = false; // 사용자 상호작용 확인

  // 사용하지 않음 - 하드코딩된 음성 파일 제거

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
    
    // 화면 진입 후 바로 자막 시작 (TTS 재생 여부와 상관없이)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1초 후 자동으로 자막 시작
      Timer(const Duration(seconds: 1), () {
        if (mounted && !hasUserInteracted) {
          setState(() {
            hasUserInteracted = true;
          });
          _positionSubscription?.cancel();
          _fallbackTick = 0;
          _startTtsSyncedCaption();
          print('자동 자막 시작');
        }
      });
    });
  }

  void _setupAudioPlayer() async {
    print('오디오 플레이어 설정 완료 - TTS 동기화 모드');
    // TTS Provider와 동기화하여 백그라운드 음성과 자막 연동
  }

  // 사용하지 않음 - 하드코딩된 음성 파일 제거로 인해 비활성화

  void _startTtsSyncedCaption() {
    print('TTS 동기화 자막 시작 - 총 ${widget.scriptLines.length}개 문장');
    
    // 0.3초마다 빠르게 TTS 상태를 체크하고 자막 동기화
    _positionSubscription = Stream.periodic(const Duration(milliseconds: 300))
        .listen((_) async {
          if (!mounted) return;
          
          final ttsProvider = Provider.of<TtsProvider>(context, listen: false);
          
          // TTS가 재생 중이고 현재 기사와 일치하는지 확인
          if (ttsProvider.isPlaying && 
              ttsProvider.currentArticle?.id == widget.articleId &&
              ttsProvider.currentAudioPlayer != null) {
            
            // 실제 TTS 재생 위치를 가져와서 자막 동기화
            try {
              final audioPlayer = ttsProvider.currentAudioPlayer!;
              final position = await audioPlayer.position;
              final totalDuration = await audioPlayer.duration;
              
              if (totalDuration != null && position != null && 
                  totalDuration.inMilliseconds > 0) {
                _updateCaptionFromTtsPosition(position, totalDuration);
                return; // TTS 동기화 성공하면 fallback 안 함
              }
            } catch (e) {
              print('TTS 위치 가져오기 실패: $e');
            }
          }
          
          // TTS 동기화 실패하거나 재생 중이 아니면 기본 타이머
          _fallbackToTimer();
        });
  }
  
  void _updateCaptionFromTtsPosition(Duration position, Duration totalDuration) {
    // TTS 전체 시간을 문장 수로 나누어 각 문장의 시간 계산
    final totalSeconds = totalDuration.inMilliseconds / 1000.0;
    final currentSeconds = position.inMilliseconds / 1000.0;
    final scriptCount = widget.scriptLines.length;
    
    if (scriptCount <= 1) return;
    
    // 현재 재생 위치에 맞는 문장 계산
    final expectedLineIndex = ((currentSeconds / totalSeconds) * scriptCount).floor();
    final clampedIndex = expectedLineIndex.clamp(0, scriptCount - 1);
    
    if (currentLyricIndex != clampedIndex) {
      setState(() {
        currentLyricIndex = clampedIndex;
        currentLine = clampedIndex;
      });
      _scrollToCurrentLine();
      print('TTS 동기화: $clampedIndex번째 문장 (${currentSeconds.toStringAsFixed(1)}s/${totalSeconds.toStringAsFixed(1)}s)');
    }
  }
  
  int _fallbackTick = 0;
  void _fallbackToTimer() {
    // TTS가 없을 때의 기본 타이머 (3초마다 넘어감)
    _fallbackTick++;
    final shouldMoveToNext = _fallbackTick % 6 == 0; // 0.5초 * 6 = 3초
    
    if (shouldMoveToNext && currentLyricIndex < widget.scriptLines.length - 1) {
      setState(() {
        currentLyricIndex++;
        currentLine = currentLyricIndex;
      });
      _scrollToCurrentLine();
      print('기본 타이머: $currentLyricIndex번째 문장으로 이동');
    } else if (currentLyricIndex >= widget.scriptLines.length - 1) {
      _positionSubscription?.cancel();
      print('모든 문장 완료');
    }
  }

  void _startAutoPlay() async {
    if (!hasUserInteracted) {
      setState(() {
        hasUserInteracted = true;
      });
    }
    
    // 기존 subscription 정리
    _positionSubscription?.cancel();
    _fallbackTick = 0; // 카운터 초기화
    
    // TTS 동기화 자막 시작
    _startTtsSyncedCaption();
    print('자막 시작');
  }

  // 음성 기반 업데이트 함수들 - 하드코딩된 음성 파일 제거로 인해 비활성화

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
    _positionSubscription?.cancel();
    _scrollController.dispose();
    _titleAnimationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin을 위해 필요
    
    // 아이폰 15 사이즈 기준 레이아웃
    return Consumer<TtsProvider>(
      builder: (context, ttsProvider, child) {
        // TTS 상태가 변경되면 자막도 자동 시작/동기화
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!hasUserInteracted && 
              ttsProvider.isPlaying && 
              ttsProvider.currentArticle?.id == widget.articleId) {
            setState(() {
              hasUserInteracted = true;
            });
            _positionSubscription?.cancel();
            _fallbackTick = 0;
            _startTtsSyncedCaption();
            print('TTS 상태 변화 감지: 자막 자동 시작');
          }
        });
        
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
                        child: widget.imageUrl.isNotEmpty
                            ? Image.network(
                                widget.imageUrl,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                      size: 32,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 32,
                                ),
                              ),
                      ),
                      const SizedBox(width: 20),
                      // 카테고리명 추가
                      // 카테고리명(파란색 배경) Container 부분 삭제
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
                      // 즐겨찾기 하트 아이콘
                      Consumer<FavoritesProvider>(
                        builder: (context, favoritesProvider, child) {
                          final isFavorite = favoritesProvider.isFavorite(widget.articleId ?? '');
                          return GestureDetector(
                            onTap: () {
                              if (widget.articleId != null) {
                                // ArticleModel을 생성해서 즐겨찾기에 추가/제거
                                // 간단한 ArticleModel 생성 (실제로는 더 많은 정보가 필요할 수 있음)
                                final article = ArticleModel(
                                  id: widget.articleId!,
                                  title: widget.title,
                                  author: widget.reporter,
                                  thumbnailImageUrl: widget.imageUrl,
                                );
                                favoritesProvider.toggleFavorite(article);
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
                              fontWeight: idx == currentLine 
                                  ? FontWeight.w900  // 현재 읽는 줄: 매우 굵게
                                  : FontWeight.w400, // 나머지 줄: 보통 굵기
                              fontFamily: 'Arial', // 기본 폰트로 변경
                              color: Colors.black, // 모든 텍스트를 검은색으로 통일
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // 하단 3개 아이콘을 briefing_screen.dart와 동일하게 배치
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, left: 32, right: 32),
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
                      // 신문 아이콘 (기사 원문보기)
                      GestureDetector(
                        onTap: () {
                          if (widget.articleUrl != null && widget.articleUrl!.isNotEmpty) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BriArticleTextScreen(
                                  title: widget.title,
                                  url: widget.articleUrl!,
                                ),
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
              ],
            ),
          ),
        ),
      ),
    );
      }, // Consumer 닫기
    );
  }
}
