import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/news_service.dart';
import '../../models/common_models.dart';
import '../../models/article_models.dart';

class NewsItem {
  final int id;
  final String date;
  final String title;
  final String source;
  final String? imageUrl;

  NewsItem({
    required this.id,
    required this.date,
    required this.title,
    required this.source,
    this.imageUrl,
  });
}

class KeywordNewsScreen extends StatefulWidget {
  const KeywordNewsScreen({Key? key}) : super(key: key);

  @override
  State<KeywordNewsScreen> createState() => _KeywordNewsScreenState();
}

class _KeywordNewsScreenState extends State<KeywordNewsScreen> {
  final ApiService _apiService = ApiService();
  final NewsService _newsService = NewsService();
  
  List<String> _userKeywords = [];
  Map<String, List<ArticleModel>> _keywordArticles = {};
  bool _isLoading = false;
  bool _isLoadingKeywords = false;

  Set<int> clickedItems = {};

  @override
  void initState() {
    super.initState();
    _loadUserKeywords();
  }

  // 사용자 키워드 로드
  Future<void> _loadUserKeywords() async {
    try {
      setState(() {
        _isLoadingKeywords = true;
      });
      
      final userKeywords = await _apiService.getUserKeywords();
      setState(() {
        _userKeywords = userKeywords.keywords ?? [];
        _isLoadingKeywords = false;
      });
      
      print('로드된 사용자 키워드: $_userKeywords');
      
      // 키워드별 기사 로드
      if (_userKeywords.isNotEmpty) {
        _loadKeywordArticles();
      }
      
    } catch (e) {
      print('사용자 키워드 로드 에러: $e');
      setState(() {
        _isLoadingKeywords = false;
      });
    }
  }

  // 키워드별 기사 로드
  Future<void> _loadKeywordArticles() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // 각 키워드별로 기사 로드
      for (final keyword in _userKeywords) {
        try {
          final articles = await _newsService.getRecommendedArticles();
          setState(() {
            _keywordArticles[keyword] = articles;
          });
          print('$keyword 키워드 기사 ${articles.length}개 로드 완료');
        } catch (e) {
          print('$keyword 키워드 기사 로드 실패: $e');
        }
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('키워드별 기사 로드 에러: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleNewsClick(int itemId) {
    setState(() {
      if (clickedItems.contains(itemId)) {
        clickedItems.remove(itemId);
      } else {
        clickedItems.add(itemId);
      }
    });
  }

  // 키워드별 기사를 NewsItem으로 변환
  List<NewsItem> _getNewsItems() {
    List<NewsItem> items = [];
    int itemId = 1;
    
    for (final keyword in _userKeywords) {
      final articles = _keywordArticles[keyword] ?? [];
      for (final article in articles.take(2)) { // 각 키워드당 최대 2개 기사
        items.add(NewsItem(
          id: itemId++,
          date: article.publishedAt != null 
              ? '${article.publishedAt!.year}/${article.publishedAt!.month.toString().padLeft(2, '0')}/${article.publishedAt!.day.toString().padLeft(2, '0')}'
              : '날짜 없음',
          title: article.title ?? '제목 없음',
          source: article.author ?? '출처 없음',
          imageUrl: article.thumbnailImageUrl,
        ));
      }
    }
    
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final newsItems = _getNewsItems();
    
    // iPhone 15 화면 크기: 393 x 852
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Center(
        child: Container(
          width: 393,
          height: 852,
          color: const Color(0xFFF9FAFB),
          child: Column(
            children: [
              // 헤더
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.chevron_left,
                          color: Color(0xFF0565FF), size: 24),
                      label: const Text('뒤로',
                          style: TextStyle(
                            color: Color(0xFF0565FF),
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF0565FF),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const Text(
                      '키워드별 뉴스',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    // 완료 버튼 제거
                    const SizedBox(width: 50),
                  ],
                ),
              ),
              // 내용
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // 로딩 상태 또는 키워드별 뉴스 그리드
                      Expanded(
                        child: _isLoadingKeywords
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : _userKeywords.isEmpty
                                ? const Center(
                                    child: Text(
                                      '선택된 키워드가 없습니다.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : newsItems.isEmpty
                                        ? const Center(
                                            child: Text(
                                              '키워드별 뉴스가 없습니다.',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                        : GridView.builder(
                                            itemCount: newsItems.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 16,
                                              crossAxisSpacing: 16,
                                              childAspectRatio: 1.2,
                                            ),
                                            itemBuilder: (context, index) {
                                              final item = newsItems[index];
                                              final isClicked = clickedItems.contains(item.id);
                                              return GestureDetector(
                                                onTap: () => handleNewsClick(item.id),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(20),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.04),
                                                        blurRadius: 4,
                                                        offset: const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  padding: const EdgeInsets.all(10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      // 날짜 뱃지
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(
                                                            horizontal: 12, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: isClicked
                                                              ? Colors.blue
                                                              : const Color(0xFFE5E7EB),
                                                          borderRadius:
                                                              BorderRadius.circular(999),
                                                        ),
                                                        child: Text(
                                                          item.date,
                                                          style: TextStyle(
                                                            color: isClicked
                                                                ? Colors.white
                                                                : const Color(0xFF374151),
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 12),
                                                      // 뉴스 이미지 자리
                                                      Container(
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFF3F4F6),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            '뉴스 사진',
                                                            style: TextStyle(
                                                              color: Color(0xFF9CA3AF),
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
