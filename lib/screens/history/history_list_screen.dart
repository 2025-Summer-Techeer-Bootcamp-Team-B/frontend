import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'history_click_screen.dart';
import '../briefing/bri_playlist.dart';
import '../home/home_screen.dart';
import '../../providers/history_provider.dart';
import '../../models/article_models.dart';
import '../briefing/briefing_screen.dart';
import '../home/home_screen.dart';
import '../favorites/favorites_screen.dart';
import '../settings/setting_screen.dart';

class HistoryListScreen extends StatelessWidget {
  const HistoryListScreen({super.key});

  void _onItemTapped(BuildContext context, int index) {
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
    final prevScreen = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Consumer<HistoryProvider>(
          builder: (context, historyProvider, child) {
            final playHistory = historyProvider.playHistory;
            
            return Column(
              children: [
                // 상단 헤더 (전체화면에 맞게 패딩 조정)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 60, // 상태바 높이 고려
                    left: 20,
                    right: 20,
                    bottom: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (prevScreen == 'home') {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const CustomHomeScreen()),
                            );
                          } else if (prevScreen == 'briefing') {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const BriPlaylistScreen()),
                            );
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_back_ios_new_rounded,
                                color: Color(0xFF0565FF), size: 24),
                            SizedBox(width: 2),
                            Text('뒤로',
                                style: TextStyle(
                                    color: Color(0xFF0565FF),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18)),
                          ],
                        ),
                      ),
                      const Text('재생기록',
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      GestureDetector(
                        onTap: () {
                          // 재생 기록 초기화
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('재생 기록 초기화'),
                              content: const Text('모든 재생 기록을 삭제하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    historyProvider.clearHistory();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('삭제'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('초기화',
                            style: TextStyle(
                                color: Color(0xFF0565FF),
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                      ),
                    ],
                  ),
                ),
                
                // 본문 리스트
                Expanded(
                  child: playHistory.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                '재생 기록이 없습니다',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '뉴스를 재생하면 여기에 기록됩니다',
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
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          itemCount: playHistory.length,
                          itemBuilder: (context, index) {
                            final article = playHistory[index];
                            return _buildHistoryCard(article, historyProvider);
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
        currentIndex: 2, // 재생기록 탭
        onTap: (index) => _onItemTapped(context, index),
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

  Widget _buildHistoryCard(ArticleModel article, HistoryProvider historyProvider) {
    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                        // 액션 버튼들
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
                            // 재생 기록에서 제거 버튼
                            GestureDetector(
                              onTap: () {
                                historyProvider.removeFromHistory(article.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('재생 기록에서 제거되었습니다.'),
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
                                  Icons.delete_outline,
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
      ),
    );
  }
}
