import 'package:flutter/material.dart';
import 'history_click_screen.dart';

// 예시 데이터
final List<Category> selectedCategories = [
  Category(
    name: '정치',
    icon: Icons.gavel, // 망치 아이콘
    articles: [
      Article(image: null, date: '25/07/09', summary: '정치 기사 1 요약'),
      Article(image: null, date: '25/07/08', summary: '정치 기사 2 요약'),
      Article(image: null, date: '25/07/05', summary: '정치 기사 3 요약'),
    ],
  ),
  Category(
    name: '경제',
    icon: Icons.attach_money,
    articles: [
      Article(image: null, date: '25/07/09', summary: '경제 기사 1 요약'),
      Article(image: null, date: '25/07/08', summary: '경제 기사 2 요약'),
      Article(image: null, date: '25/07/05', summary: '경제 기사 3 요약'),
    ],
  ),
  Category(
    name: '이슈',
    icon: Icons.whatshot,
    articles: [
      Article(image: null, date: '25/07/09', summary: '이슈 기사 1 요약'),
      Article(image: null, date: '25/07/08', summary: '이슈 기사 2 요약'),
      Article(image: null, date: '25/07/05', summary: '이슈 기사 3 요약'),
    ],
  ),
];

class HistoryListScreen extends StatelessWidget {
  const HistoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // 배경색
      body: Center(
        child: Container(
          width: 360, // 카드 폭 (Figma 기준)
          height: 700, // 카드 높이 (원하는 비율로 조정)
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32), // 라운드
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
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
                        Navigator.pop(context);
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
                  padding: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 24),
                  itemCount: selectedCategories.length,
                  itemBuilder: (context, idx) {
                    final category = selectedCategories[idx];
                    Widget card = Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: CategoryCard(category: category),
                    );
                    // 정치, 경제, 이슈 카테고리 클릭 시 이동
                    if (category.name == '정치' || category.name == '경제' || category.name == '이슈') {
                      card = GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HistoryClickScreen(categoryName: category.name),
                            ),
                          );
                        },
                        child: card,
                      );
                    }
                    return Align(
                      alignment: Alignment.topCenter,
                      child: card,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330, // 카드 폭을 약간 넓힘
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 카테고리명(파란 배경+아이콘)
          Positioned(
            left: 20,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // 파란 배경 패딩 줄임
              decoration: BoxDecoration(
                color: const Color(0xFF0565FF),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 18), // 더 넓은 간격
                  Icon(category.icon, color: Colors.white, size: 22),
                ],
              ),
            ),
          ),
          // 기사 카드들 (가로 스크롤)
          Positioned(
            left: 0,
            right: 0,
            top: 60,
            bottom: 0,
            child: Center(
              child: SizedBox(
                width: 260, // 카드 내부 리스트의 최대 폭 제한 (카드 폭보다 작게)
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: category.articles.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, idx) {
                    final article = category.articles[idx];
                    return ArticleCard(article: article, highlight: idx == 0);
                  },
                ),
              ),
            ),
          ),
        ],
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
      width: 90,
      height: 140,
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
            width: 64,
            height: 64,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: article.image != null
                ? Image.asset(article.image!, fit: BoxFit.cover)
                : const Icon(Icons.image, color: Colors.grey, size: 28),
          ),
          const SizedBox(height: 4),
          // 날짜
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color:
                  highlight ? const Color(0xFF0565FF) : const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(12),
              boxShadow: highlight
                  ? [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ]
                  : [],
            ),
            child: Text(
              article.date,
              style: TextStyle(
                color: highlight ? Colors.white : Colors.black,
                fontSize: 11,
              ),
            ),
          ),
          // 기사 요약(내용) 추가
          if (article.summary != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                article.summary!,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// 데이터 모델은 이전과 동일하게 사용
class Category {
  final String name;
  final IconData icon;
  final List<Article> articles;
  Category({required this.name, required this.icon, required this.articles});
}

class Article {
  final String? image;
  final String date;
  final String? summary;
  Article({this.image, required this.date, this.summary});
}
