import 'package:flutter/material.dart';
import '../briefing/bri_playlist.dart';
import '../favorites/fav_s_t_off.dart';
import '../history/history_list_screen.dart';
import '../settings/setting_screen.dart';
import '../briefing/keyword_news.dart';
import '../briefing/briefing_screen.dart';
import '../../services/news_service.dart';
import '../../models/article_models.dart';
import '../../providers/tts_provider.dart'; // TtsProvider 추가
import 'package:provider/provider.dart'; // Consumer 추가
import '../../providers/user_preferences_provider.dart'; // UserPreferencesProvider 추가
import '../../services/api_service.dart'; // ApiService 추가
import '../../models/common_models.dart'; // UserCategories, UserPress 추가

class CustomHomeScreen extends StatefulWidget {
  const CustomHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomHomeScreen> createState() => _CustomHomeScreenState();
}

class _CustomHomeScreenState extends State<CustomHomeScreen> {
  final int _selectedIndex = 0;
  bool _isPlaying = false;
  String _playingTitle = '';

  // API 서비스 인스턴스
  final NewsService _newsService = NewsService();
  final ApiService _apiService = ApiService(); // ApiService 추가

  // 뉴스 데이터 상태
  List<ArticleModel> _breakingNews = [];
  List<ArticleModel> _keywordNews = [];
  Map<String, List<ArticleModel>> _categoryArticles = {}; // 카테고리별 기사 저장
  bool _isLoading = false;
  
  // 사용자 설정 상태 추가
  List<String> _userCategories = [];
  List<String> _userPress = [];
  bool _isLoadingUserPreferences = false;

  @override
  void initState() {
    super.initState();
    _loadNewsData();
    _loadRecommendedNews();
    _loadUserPreferences();
  }

  // 사용자 설정 로드 (API 직접 호출)
  Future<void> _loadUserPreferences() async {
    try {
      setState(() {
        _isLoadingUserPreferences = true;
      });
      
      // 사용자 카테고리와 언론사 동시에 로드
      final categoriesFuture = _apiService.getUserCategories();
      final pressFuture = _apiService.getUserPress();
      
      final results = await Future.wait([categoriesFuture, pressFuture]);
      
      final userCategories = results[0] as UserCategories;
      final userPress = results[1] as UserPress;
      
      setState(() {
        _userCategories = userCategories.categories ?? [];
        _userPress = userPress.press ?? [];
        _isLoadingUserPreferences = false;
      });
      
      // 디버깅용 로그
      print('로드된 사용자 카테고리: $_userCategories');
      print('로드된 사용자 언론사: $_userPress');
      
      // 사용자 카테고리별 기사 로드
      if (_userCategories.isNotEmpty) {
        _loadUserCategoryArticles();
      }
      
    } catch (e) {
      print('사용자 설정 로드 에러: $e');
      setState(() {
        _isLoadingUserPreferences = false;
      });
    }
  }

  // 사용자 카테고리별 기사 로드
  Future<void> _loadUserCategoryArticles() async {
    try {
      print('사용자 카테고리별 기사 로드 시작: $_userCategories');
      
      // 각 카테고리별로 기사 로드
      for (final category in _userCategories) {
        try {
          final articles = await _newsService.getPreferredCategoryArticles(category);
          setState(() {
            _categoryArticles[category] = articles;
          });
          print('$category 카테고리 기사 ${articles.length}개 로드 완료');
        } catch (e) {
          print('$category 카테고리 기사 로드 실패: $e');
        }
      }
    } catch (e) {
      print('사용자 카테고리 기사 로드 에러: $e');
    }
  }

  // 뉴스 데이터 로드
  Future<void> _loadNewsData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 각각 await로 받아서 타입 에러 방지
      final breakingNews = await _newsService.getBreakingNews();
      // final keywordNewsResponse = await _newsService.getKeywordNews(keyword: '인기');
      // final keywordNews = keywordNewsResponse.articles;

      setState(() {
        _breakingNews = breakingNews;
        // _keywordNews = keywordNews;
        _isLoading = false;
      });
    } catch (e) {
      print('뉴스 데이터 로드 에러: $e');
      setState(() {
        _isLoading = false;
      });

      // 에러 발생 시 사용자에게 알림
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('뉴스를 불러오는데 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 추천 뉴스 데이터 로드
  Future<void> _loadRecommendedNews() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final recommended = await _newsService.getRecommendedArticles();
      setState(() {
        _keywordNews = recommended;
        _isLoading = false;
      });
      
      print('키워드별 뉴스 ${recommended.length}개 로드 완료');
    } catch (e) {
      print('추천 뉴스 데이터 로드 에러: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 카테고리별 기사 로드
  Future<void> _loadCategoryArticles(String categoryName) async {
    try {
      final articles = await _newsService.getPreferredCategoryArticles(categoryName);
      setState(() {
        _categoryArticles[categoryName] = articles;
      });
    } catch (e) {
      print('카테고리 기사 로드 에러: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$categoryName 카테고리 뉴스를 불러오는데 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 카테고리별 아이콘 경로 매핑 함수
  String _getCategoryIconPath(String categoryName) {
    switch (categoryName) {
      case 'IT':
        return 'assets/a_image/IT_icon.webp';
      case '경제':
        return 'assets/a_image/economy.png';
      case '국제':
        return 'assets/a_image/global_icon.png';
      case '문화':
        return 'assets/a_image/culture_icon.webp';
      case '부동산':
        return 'assets/a_image/real_estate_icon.png';
      case '사회':
        return 'assets/a_image/society_icon.webp';
      case '스포츠':
        return 'assets/a_image/sport_icon.png';
      case '연예':
        return 'assets/a_image/entertainment_icon.webp';
      case '정치':
        return 'assets/a_image/politics_icon.webp';
      case '증권':
        return 'assets/a_image/certificate_icon.webp';
      default:
        return 'assets/a_image/economy.png'; // 기본값
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const CustomHomeScreen()));
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const FavoritesCategoryScreen(),
          settings: const RouteSettings(arguments: 'home'),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HistoryListScreen(),
          settings: const RouteSettings(arguments: 'home'),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SettingScreen(),
          settings: const RouteSettings(arguments: 'home'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 타이틀 (프로필 사진 제거)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '홈',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // 나머지 영역 스크롤 가능하게 Expanded+SingleChildScrollView
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // 실시간 속보 섹션 (가로 스크롤)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/a_image/home_newsflash_icon.png',
                            width: 32,
                            height: 32,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              '실시간 속보',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 240, // 카드 높이 조정
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _breakingNews.length, // 받아온 기사 개수만큼
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, idx) {
                          final article = _breakingNews[idx];
                          return _buildBreakingNewsCard(article);
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    // 오늘의 뉴스 섹션
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const BriPlaylistScreen(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '오늘의 뉴스',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _isLoadingUserPreferences
                        ? const SizedBox(
                            height: 120,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : _userCategories.isEmpty
                            ? const SizedBox(
                                height: 120,
                                child: Center(
                                  child: Text(
                                    '선택된 카테고리가 없습니다.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 120,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  itemCount: _userCategories.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                                  itemBuilder: (context, index) {
                                    final category = _userCategories[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => BriPlaylistScreen(selectedCategory: category),
                                          ),
                                        );
                                      },
                                      child: _buildTodayNewsCard(
                                        category: category,
                                        iconPath: _getCategoryIconPath(category),
                                      ),
                                    );
                                  },
                                ),
                              ),
                    const SizedBox(height: 18),
                    // 키워드별 뉴스 섹션
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const KeywordNewsScreen(),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Text(
                              '키워드별 뉴스',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right, color: Color(0xFF0565FF)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 키워드별 뉴스 섹션에서 _keywordNews 사용
                    _isLoading
                        ? const SizedBox(
                            height: 240,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : _keywordNews.isEmpty
                            ? const SizedBox(
                                height: 240,
                                child: Center(
                                  child: Text(
                                    '키워드별 뉴스가 없습니다.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 240,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  itemCount: _keywordNews.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                                  itemBuilder: (context, idx) {
                                    final article = _keywordNews[idx];
                                    return GestureDetector(
                                      onTap: () {
                                        if (article != null) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => BriefingScreen(article: article),
                                            ),
                                          );
                                        }
                                      },
                                      child: _buildKeywordNewsCard(article), // article을 파라미터로 전달
                                    );
                                  },
                                ),
                              ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
            // 재생바
            _buildPlayerBar(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0565FF),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
        // BottomNavigationBar 높이 늘리기
        // Flutter 기본 BottomNavigationBar는 height 조정이 직접 안 되므로, 아이콘/텍스트 크기와 패딩으로 높임
      ),
    );
  }

  // Apple Podcast 스타일 실시간 속보 카드
  Widget _buildPodcastStyleCard() {
    return Container(
      width: 200,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          // 앨범/썸네일 이미지 (임시 아이콘)
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              width: 160,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.podcasts,
                  size: 60, color: Color(0xFF7B6F5B)),
            ),
          ),
          // 날짜
          Positioned(
            top: 140,
            left: 20,
            child: Text(
              '2024. 09. 19.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // 제목(굵게)
          const Positioned(
            top: 160,
            left: 20,
            right: 20,
            child: Text(
              '케이팝 데몬 헌터스 OST, 빌보드 차트...',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 부제목(파란색, 연합뉴스)
          const Positioned(
            top: 182,
            left: 20,
            right: 20,
            child: Text(
              '연합뉴스',
              style: TextStyle(
                color: Color(0xFF0565FF),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 재생 버튼 + 시간
          Positioned(
            bottom: 16,
            left: 20,
            child: Padding(
              padding: const EdgeInsets.only(top: 22.0), // 연합뉴스와 흰색 네모 간격 더 넓힘
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, size: 16, color: Colors.black),
                    SizedBox(width: 3),
                    Text(
                      '60분',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 옵션 ...
          const Positioned(
            bottom: 16,
            right: 20,
            child: Icon(Icons.more_horiz, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayNewsCard(
      {required String category, required String iconPath}) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 32, height: 32, fit: BoxFit.contain),
          const SizedBox(height: 18),
          Text(
            category,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordNewsCard(ArticleModel? article) {
    return Container(
      width: 200,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 기사 썸네일 이미지
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              width: 140,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: article?.thumbnailImageUrl != null && article!.thumbnailImageUrl!.isNotEmpty
                    ? Image.network(
                        article.thumbnailImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 60, color: Color(0xFF7B6F5B)),
                      )
                    : const Icon(Icons.podcasts, size: 60, color: Color(0xFF7B6F5B)),
              ),
            ),
          ),
          // 날짜
          Positioned(
            top: 140,
            left: 20,
            child: Text(
              article?.publishedAt != null ? article!.publishedAt!.toIso8601String().split('T').first : '날짜 없음',
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // 제목(굵게)
          Positioned(
            top: 160,
            left: 20,
            right: 20,
            child: Text(
              article?.title ?? '제목 없음',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 출처(파란색)
          Positioned(
            top: 182,
            left: 20,
            right: 20,
            child: Text(
              article?.author ?? '출처 없음',
              style: const TextStyle(
                color: Color(0xFF0565FF),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 재생 버튼 + 시간 - 듣기 버튼만 클릭 가능
          Positioned(
            bottom: 16,
            left: 20,
            child: Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: GestureDetector(
                onTap: () {
                  if (article != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BriefingScreen(article: article, autoPlay: true),
                      ),
                    );
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0565FF),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, size: 16, color: Colors.white),
                      SizedBox(width: 3),
                      Text(
                        '듣기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 옵션 ...
          const Positioned(
            bottom: 16,
            right: 20,
            child: Icon(Icons.more_horiz, color: Colors.grey),
          ),
          // 전체 카드 클릭 영역 (듣기 버튼 제외)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () {
                  if (article != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BriefingScreen(article: article, autoPlay: false),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerBar() {
    return Consumer<TtsProvider>(
      builder: (context, tts, child) {
        final article = tts.currentArticle;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0565FF).withOpacity(0.13),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
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
                              style: TextStyle(fontSize: 10, color: Colors.black54, fontFamily: 'Pretendard'),
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        child: Text(
                          '뉴스\n사진',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.black54, fontFamily: 'Pretendard'),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  (!tts.hasPlayedOnce) ? '재생 중이 아님' : (article?.title ?? '기사 제목'),
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(
                  tts.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: tts.isPlaying ? 28 : 32,
                  color: Colors.black,
                ),
                onPressed: () async {
                  try {
                    if (tts.isPlaying) {
                      tts.pause();
                    } else if (tts.currentArticle != null) {
                      if (tts.currentAudioPlayer != null) {
                        tts.play(tts.currentArticle!, audioPlayer: tts.currentAudioPlayer);
                        await tts.currentAudioPlayer!.play();
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BriefingScreen(article: tts.currentArticle),
                          ),
                        );
                      }
                    }
                  } catch (e) {
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
    );
  }

  // 실시간 속보 기사 카드 위젯
  Widget _buildBreakingNewsCard(ArticleModel article) {
    return Container(
      width: 200,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          // 카드 전체 클릭 (듣기 버튼 영역 제외)
          GestureDetector(
            onTap: () {
              // 카드 다른 부분 클릭 시 BriefingScreen으로 이동 (자동 재생 X)
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BriefingScreen(article: article, autoPlay: false),
                ),
              );
            },
            child: Container(
              width: 200,
              height: 220,
              child: Stack(
                children: [
                  // 썸네일 이미지
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      width: 160,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: article.thumbnailImageUrl != null && article.thumbnailImageUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                article.thumbnailImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 60, color: Color(0xFF7B6F5B)),
                              ),
                            )
                          : const Icon(Icons.podcasts, size: 60, color: Color(0xFF7B6F5B)),
                    ),
                  ),
                  // 날짜
                  Positioned(
                    top: 140,
                    left: 20,
                    child: Text(
                      article.publishedAt != null ? article.publishedAt!.toIso8601String().split('T').first : '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  // 제목(굵게)
                  Positioned(
                    top: 160,
                    left: 20,
                    right: 20,
                    child: Text(
                      article.title ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 부제목(파란색, 언론사)
                  Positioned(
                    top: 182,
                    left: 20,
                    right: 20,
                    child: Text(
                      article.author ?? '',
                      style: const TextStyle(
                        color: Color(0xFF0565FF),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 옵션 ...
                  const Positioned(
                    bottom: 16,
                    right: 20,
                    child: Icon(Icons.more_horiz, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          // 듣기 버튼만 Stack의 마지막 child로 분리
          Positioned(
            bottom: 16,
            left: 20,
            child: GestureDetector(
              onTap: () {
                // 듣기 버튼 클릭 시 BriefingScreen으로 이동 (자동 재생 O)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BriefingScreen(article: article, autoPlay: true),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, size: 16, color: Colors.black),
                    SizedBox(width: 3),
                    Text(
                      '듣기',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryArticleCard(ArticleModel article) {
    return Container(
      width: 200,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 기사 썸네일 이미지
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              width: 140,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: article.thumbnailImageUrl != null && article.thumbnailImageUrl!.isNotEmpty
                    ? Image.network(
                        article.thumbnailImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 60, color: Color(0xFF7B6F5B)),
                      )
                    : const Icon(Icons.podcasts, size: 60, color: Color(0xFF7B6F5B)),
              ),
            ),
          ),
          // 날짜
          Positioned(
            top: 140,
            left: 20,
            child: Text(
              article.publishedAt != null ? article.publishedAt!.toIso8601String().split('T').first : '',
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // 제목(굵게)
          Positioned(
            top: 160,
            left: 20,
            right: 20,
            child: Text(
              article.title ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 출처(파란색)
          Positioned(
            top: 182,
            left: 20,
            right: 20,
            child: Text(
              article.author ?? '',
              style: const TextStyle(
                color: Color(0xFF0565FF),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 재생 버튼 + 시간
          Positioned(
            bottom: 16,
            left: 20,
            child: Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0565FF),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, size: 16, color: Colors.white),
                    SizedBox(width: 3),
                    Text(
                      '60분',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 옵션 ...
          const Positioned(
            bottom: 16,
            right: 20,
            child: Icon(Icons.more_horiz, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

