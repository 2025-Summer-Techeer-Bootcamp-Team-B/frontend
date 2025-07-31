import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/article_models.dart';
import '../../providers/favorites_provider.dart';
import '../briefing/briefing_screen.dart';
import '../home/home_screen.dart';
import '../history/history_list_screen.dart';
import '../settings/setting_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const CustomHomeScreen()));
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const FavoritesScreen(),
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
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            final favorites = favoritesProvider.favoriteArticles;
            
            // 카테고리별로 그룹화
            final Map<String, List<ArticleModel>> groupedFavorites = {};
            for (final article in favorites) {
              final category = article.categoryName ?? '기타';
              if (!groupedFavorites.containsKey(category)) {
                groupedFavorites[category] = [];
              }
              groupedFavorites[category]!.add(article);
            }
            
            return Column(
              children: [
                // 상단 헤더
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: Color(0xFF0565FF),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        '즐겨찾기',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showSortOptions(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.sort,
                            size: 20,
                            color: Color(0xFF0565FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 즐겨찾기 목록
                Expanded(
                  child: favorites.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                '즐겨찾기한 뉴스가 없습니다',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '브리핑 화면에서 하트 버튼을 눌러\n뉴스를 즐겨찾기에 추가해보세요',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontFamily: 'Pretendard',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: groupedFavorites.length,
                          itemBuilder: (context, index) {
                            final category = groupedFavorites.keys.elementAt(index);
                            final articles = groupedFavorites[category]!;
                            return _buildCategorySection(category, articles, favoritesProvider);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0565FF),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: 1, // 즐겨찾기 탭
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
      ),
    );
  }

  Widget _buildCategorySection(String category, List<ArticleModel> articles, FavoritesProvider favoritesProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카테고리 헤더
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0565FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0565FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0565FF),
                    fontFamily: 'Pretendard',
                  ),
                ),
                const Spacer(),
                Text(
                  '${articles.length}개',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0565FF),
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 카테고리 내 기사들
          ...articles.map((article) => _buildFavoriteCard(article, favoritesProvider)),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(ArticleModel article, FavoritesProvider favoritesProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BriefingScreen(article: article),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 썸네일 이미지
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: article.thumbnailImageUrl != null && article.thumbnailImageUrl!.isNotEmpty
                        ? Image.network(
                            article.thumbnailImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.article,
                              size: 40,
                              color: Color(0xFF7B6F5B),
                            ),
                          )
                        : const Icon(
                            Icons.article,
                            size: 40,
                            color: Color(0xFF7B6F5B),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                // 기사 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목
                      Text(
                        article.title ?? '제목 없음',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'Pretendard',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // 출처와 날짜
                      Row(
                        children: [
                          Text(
                            article.author ?? '출처 없음',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0565FF),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            article.publishedAt != null 
                                ? article.publishedAt!.toIso8601String().split('T').first 
                                : '날짜 없음',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 재생 버튼
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0565FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '재생',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // 즐겨찾기 제거 버튼
                          GestureDetector(
                            onTap: () {
                              favoritesProvider.removeFromFavorites(article.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('즐겨찾기에서 제거되었습니다.'),
                                  backgroundColor: Color(0xFF0565FF),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 16,
                              ),
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

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '정렬 옵션',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.access_time, color: Color(0xFF0565FF)),
              title: const Text('최신순', style: TextStyle(fontFamily: 'Pretendard')),
              onTap: () {
                Navigator.pop(context);
                // 최신순 정렬 로직
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Color(0xFF0565FF)),
              title: const Text('즐겨찾기 순', style: TextStyle(fontFamily: 'Pretendard')),
              onTap: () {
                Navigator.pop(context);
                // 즐겨찾기 순 정렬 로직
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
} 