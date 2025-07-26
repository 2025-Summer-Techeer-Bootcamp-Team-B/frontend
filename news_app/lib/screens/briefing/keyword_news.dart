import 'package:flutter/material.dart';

class NewsItem {
  final int id;
  final String date;
  final String title;
  final String source;

  NewsItem({
    required this.id,
    required this.date,
    required this.title,
    required this.source,
  });
}

class KeywordNewsScreen extends StatefulWidget {
  const KeywordNewsScreen({Key? key}) : super(key: key);

  @override
  State<KeywordNewsScreen> createState() => _KeywordNewsScreenState();
}

class _KeywordNewsScreenState extends State<KeywordNewsScreen> {
  final List<NewsItem> newsItems = [
    NewsItem(id: 1, date: "25/07/09", title: "키워드 관련 뉴스 제목 1", source: "기사 출처"),
    NewsItem(id: 2, date: "25/07/09", title: "키워드 관련 뉴스 제목 2", source: "기사 출처"),
    NewsItem(id: 3, date: "25/07/09", title: "키워드 관련 뉴스 제목 3", source: "기사 출처"),
    NewsItem(id: 4, date: "25/07/09", title: "키워드 관련 뉴스 제목 4", source: "기사 출처"),
    NewsItem(id: 5, date: "25/07/09", title: "키워드 관련 뉴스 제목 5", source: "기사 출처"),
    NewsItem(id: 6, date: "25/07/09", title: "키워드 관련 뉴스 제목 6", source: "기사 출처"),
    NewsItem(id: 7, date: "25/07/09", title: "키워드 관련 뉴스 제목 7", source: "기사 출처"),
    NewsItem(id: 8, date: "25/07/09", title: "키워드 관련 뉴스 제목 8", source: "기사 출처"),
  ];

  Set<int> clickedItems = {};

  void handleNewsClick(int itemId) {
    setState(() {
      if (clickedItems.contains(itemId)) {
        clickedItems.remove(itemId);
      } else {
        clickedItems.add(itemId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      // 뉴스 그리드
                      Expanded(
                        child: GridView.builder(
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
