import 'package:flutter/material.dart';
import 'briefing_screen.dart';
import 'package:marquee/marquee.dart';
import '../home/home_screen.dart';
import '../favorites/fav_s_t_off.dart';
import '../history/history_list_screen.dart';
import '../settings/setting_screen.dart';
import '../../models/article_models.dart';
import '../../services/news_service.dart';
import 'package:provider/provider.dart';
import '../../providers/tts_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kBlue = Color(0xFF0565FF);
const kPretendard = 'Pretendard';

class BriPlaylistScreen extends StatefulWidget {
  final String? selectedCategory;
  
  const BriPlaylistScreen({Key? key, this.selectedCategory}) : super(key: key);

  @override
  State<BriPlaylistScreen> createState() => _BriPlaylistScreenState();
}

class _BriPlaylistScreenState extends State<BriPlaylistScreen> {
  int selectedCategory = 0;
  bool isPlaying = true;
  final int _selectedIndex = 0; // 하단 네비게이션 상태
  final NewsService _newsService = NewsService();

  final List<String> categories = ['경제', '정치', '사회', 'IT', '스포츠', '문화', '국제', '연예', '증권', '부동산'];
  List<ArticleModel> _currentArticles = [];
  bool _isLoading = false;

  // 삭제한 기사 ID 저장용
  Set<String> _deletedArticleIds = {};

  // 하단 플레이어 상태 변수 추가
  ArticleModel? _currentPlayingArticle;
  bool _isTtsPlaying = false;

  @override
  void initState() {
    super.initState();
    // 삭제한 기사 불러오기
    _loadDeletedArticles();
    // 카테고리 세팅
    if (widget.selectedCategory != null) {
      final categoryIndex = categories.indexOf(widget.selectedCategory!);
      if (categoryIndex != -1) {
        selectedCategory = categoryIndex;
      }
    }
    _loadCategoryArticles(categories[selectedCategory]);
    // 기존 재생 상태 유지 (음성 멈춤 방지)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ttsProvider = Provider.of<TtsProvider>(context, listen: false);
      if (ttsProvider.isPlaying && ttsProvider.currentArticle != null) {
        print('기존 재생 상태 유지: ${ttsProvider.currentArticle!.title}');
      }
    });
  }

  Future<void> _loadDeletedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('deleted_article_ids') ?? [];
    setState(() {
      _deletedArticleIds = ids.toSet();
    });
  }

  Future<void> _saveDeletedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('deleted_article_ids', _deletedArticleIds.toList());
  }

  // 기사 삭제 시 호출
  void _deleteArticle(String articleId) async {
    setState(() {
      _deletedArticleIds.add(articleId);
      _currentArticles.removeWhere((a) => a.id == articleId);
    });
    await _saveDeletedArticles();
  }

  Future<void> _loadCategoryArticles(String categoryName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final articles = await _newsService.getPreferredCategoryArticles(categoryName);
      setState(() {
        _currentArticles = articles;
        _isLoading = false;
      });
    } catch (e) {
      print('카테고리 기사 로드 에러: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }



  void _onCategoryChanged(int index) {
    setState(() {
      selectedCategory = index;
    });
    _loadCategoryArticles(categories[index]);
  }

  @override
  Widget build(BuildContext context) {
    // 삭제된 기사 제외하고 보여주기
    final visibleArticles = _currentArticles.where((a) => !_deletedArticleIds.contains(a.id)).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(
              fontFamily: kPretendard,
              fontWeight: FontWeight.w400,
              color: Colors.black),
          child: Column(
            children: [
              // 상단 타이틀 & 아이콘
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. 첫 줄: 뒤로가기 버튼만
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const CustomHomeScreen(),
                              ),
                            );
                          },
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: kBlue, size: 28),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 2. 둘째 줄: 오늘의 뉴스 아이콘 + 텍스트
                    Row(
                      children: [
                        Image.asset(
                          'assets/a_image/pl_toadynews_icon.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            '오늘의 뉴스',
                            style: TextStyle(
                              fontFamily: kPretendard,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: kBlue,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14), // 카테고리 버튼 위 간격
              // 카테고리 탭
              SizedBox(
                height: 32,
                child: ListView.separated(
                  clipBehavior: Clip.none, // 스크롤할 때 그림자가 잘리지 않게
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, idx) {
                    final selected = selectedCategory == idx;
                    return GestureDetector(
                      onTap: () => _onCategoryChanged(idx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: selected ? kBlue : Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: selected
                                  ? kBlue.withOpacity(0.18)
                                  : Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          categories[idx],
                          style: TextStyle(
                            fontFamily: kPretendard,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: selected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20), // 카테고리 버튼 아래 간격을 늘려서 그림자가 보이게
              // 구분선
              Divider(
                height: 1,
                thickness: 1,
                color: const Color(0xFF222222).withOpacity(0.12),
              ),
              // 기사 리스트
              Expanded(
                child: ReorderableListView.builder(
                  key: ValueKey(selectedCategory),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: visibleArticles.length,
                  buildDefaultDragHandles: false,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final item = visibleArticles.removeAt(oldIndex);
                      visibleArticles.insert(newIndex, item);
                      // _currentArticles도 동기화
                      _currentArticles = visibleArticles;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final article = visibleArticles[idx];
                    return Column(
                      key: ValueKey('tile_${article.title}_${article.author}_$idx'),
                      children: [
                        Dismissible(
                          key: ValueKey('dismiss_${article.title}_${article.author}_$idx'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            color: Colors.redAccent,
                            child: const Icon(Icons.delete, color: Colors.white, size: 28),
                          ),
                          onDismissed: (direction) {
                            _deleteArticle(article.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('삭제됨')),
                            );
                          },
                          child: ListTile(
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: article.thumbnailImageUrl != null && article.thumbnailImageUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        article.thumbnailImageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => const Center(
                                          child: Text(
                                            '뉴스\n사진',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                                fontFamily: kPretendard),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                        '뉴스\n사진',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: kPretendard),
                                      ),
                                    ),
                            ),
                            title: Text(
                              article.title,
                              style: const TextStyle(
                                fontFamily: kPretendard,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              article.author ?? '',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: kBlue,
                                  fontFamily: kPretendard),
                            ),
                            trailing: ReorderableDragStartListener(
                              index: idx,
                              child: _buildDragHandle(),
                            ),
                            onTap: () {
                              // 기사 클릭 시 자동 재생하지 않고 화면만 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BriefingScreen(article: article),
                                ),
                              );
                            },
                          ),
                        ),
                        if (idx < visibleArticles.length - 1)
                          Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Colors.grey[300],
                            indent: 16,
                            endIndent: 16,
                          ),
                      ],
                    );
                  },
                ),
              ),
              // 하단 플레이어
              Consumer<TtsProvider>(
                builder: (context, tts, child) {
                  final article = tts.currentArticle;
                  print('하단 플레이어 상태: isPlaying=${tts.isPlaying}, article=${article?.title}');
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: kBlue.withOpacity(0.18),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // 썸네일
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: article != null && article.thumbnailImageUrl != null && article.thumbnailImageUrl!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    article.thumbnailImageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Center(
                                      child: Text(
                                        '뉴스\n사진',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 10, color: Colors.black54, fontFamily: kPretendard),
                                      ),
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    '뉴스\n사진',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 10, color: Colors.black54, fontFamily: kPretendard),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        // 기사 제목
                        Expanded(
                          child: Text(
                            // 처음에만 "재생 중이 아님" 표시, 재생 후에는 기사 제목 표시
                            (!tts.hasPlayedOnce) ? '재생 중이 아님' : (article?.title ?? '기사 제목'),
                            style: const TextStyle(
                              fontFamily: kPretendard,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // 재생/일시정지 버튼
                        IconButton(
                          icon: Icon(
                            tts.isPlaying ? Icons.pause : Icons.play_arrow,
                            size: tts.isPlaying ? 28 : 32,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            try {
                              // 재생/일시정지 토글
                              if (tts.isPlaying) {
                                // 일시정지
                                tts.pause();
                                print('일시정지 버튼 클릭');
                              } else if (tts.currentArticle != null) {
                                // 재생
                                if (tts.currentAudioPlayer != null) {
                                  // 먼저 TtsProvider 상태를 업데이트
                                  tts.play(tts.currentArticle!, audioPlayer: tts.currentAudioPlayer);
                                  // 그 다음 오디오 플레이어 재생
                                  await tts.currentAudioPlayer!.play();
                                  print('재생 버튼 클릭');
                                } else {
                                  // 오디오 플레이어가 없으면 BriefingScreen으로 이동
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BriefingScreen(article: tts.currentArticle),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              print('하단 플레이어 재생 오류: $e');
                              // 오류 발생 시 BriefingScreen으로 이동
                              if (tts.currentArticle != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BriefingScreen(article: tts.currentArticle),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: kBlue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const CustomHomeScreen(),
                settings: const RouteSettings(arguments: 'briefing'),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const FavoritesCategoryScreen(),
                settings: const RouteSettings(arguments: 'briefing'),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HistoryListScreen(),
                settings: const RouteSettings(arguments: 'briefing'),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingScreen(),
                settings: const RouteSettings(arguments: 'briefing'),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Icon(Icons.home, size: 32),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Icon(Icons.star_border, size: 32),
            ),
            label: '즐겨찾기',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Icon(Icons.history, size: 32),
            ),
            label: '재생기록',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Icon(Icons.settings, size: 32),
            ),
            label: '설정',
          ),
        ],
        iconSize: 32,
        selectedFontSize: 15,
        unselectedFontSize: 13,
      ),
    );
  }

  Widget _buildDragHandle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (i) => Container(
          width: 22,
          height: 3,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _CategoryButton extends StatefulWidget {
  final String label;
  final bool selected;
  const _CategoryButton({required this.label, required this.selected});

  @override
  State<_CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<_CategoryButton> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    final shadowColor =
        widget.selected || _hovering ? kBlue.withOpacity(0.25) : Colors.black12;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: widget.selected ? kBlue : Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 4), // 아래쪽으로 그림자
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 18, vertical: 12), // 세로 패딩 늘림
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: kPretendard,
              fontWeight: widget.selected ? FontWeight.w700 : FontWeight.w400,
              fontSize: 16,
              color: widget.selected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  const _NavItem({required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(iconPath, width: 28, height: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
              fontFamily: kPretendard,
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: Colors.black54),
        ),
      ],
    );
  }
}
