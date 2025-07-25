import 'package:flutter/material.dart';
import 'history_click_screen.dart';
import '../briefing/bri_playlist.dart';
import '../home/home_screen.dart';

// 예시 데이터
final List<Category> selectedCategories = [
  Category(
    name: '정치',
    iconAsset: 'assets/a_image/politics_icon.webp',
    articles: [
      Article(image: null, date: '25/07/09'),
      Article(image: null, date: '25/07/08'),
      Article(image: null, date: '25/07/05'),
    ],
  ),
  Category(
    name: '경제',
    iconAsset: 'assets/a_image/economy.png',
    articles: [
      Article(image: null, date: '25/07/09'),
      Article(image: null, date: '25/07/08'),
      Article(image: null, date: '25/07/05'),
    ],
  ),
];

class HistoryListScreen extends StatelessWidget {
  const HistoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prevScreen = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          // 상단 헤더
          Padding(
            padding:
                const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else if (prevScreen == 'home') {
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
                  onTap: () {},
                  child: const Text('완료',
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              itemCount: selectedCategories.length,
              itemBuilder: (context, idx) {
                final category = selectedCategories[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: CategoryCard(category: category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HistoryClickScreen(),
          ),
        );
      },
      child: SizedBox(
        width: 361, // 393 - 좌우 여백 16*2
        height: 220,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 흰색 네모 + 연한 그림자
            Container(
              width: 361,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            // 카테고리명(파란 배경+아이콘) - 왼쪽 상단으로 이동
            Positioned(
              left: 16,
              top: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0565FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      category.iconAsset,
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
            // 기사 카드들 (가로 스크롤)
            Positioned(
              left: 0,
              top: 60,
              right: 0,
              bottom: 0,
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                scrollDirection: Axis.horizontal,
                itemCount: category.articles.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, idx) {
                  final article = category.articles[idx];
                  return ArticleCard(article: article, highlight: idx == 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 기사 카드 (텍스트는 날짜만)
class ArticleCard extends StatelessWidget {
  final Article article;
  final bool highlight;
  const ArticleCard({super.key, required this.article, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 117,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 기사 사진 (없으면 기본)
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: article.image != null
                ? Image.asset(article.image!, fit: BoxFit.cover)
                : const Icon(Icons.image, color: Colors.grey, size: 32),
          ),
          const Spacer(),
          // 날짜
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [],
            ),
            child: Text(
              article.date,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 데이터 모델은 이전과 동일하게 사용
class Category {
  final String name;
  final String iconAsset;
  final List<Article> articles;
  Category(
      {required this.name, required this.iconAsset, required this.articles});
}

class Article {
  final String? image;
  final String date;
  Article({this.image, required this.date});
}
