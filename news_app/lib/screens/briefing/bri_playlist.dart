import 'package:flutter/material.dart';
import 'briefing_screen.dart';
import 'package:marquee/marquee.dart';

const kBlue = Color(0xFF0565FF);
const kPretendard = 'Pretendard';

class BriPlaylistScreen extends StatefulWidget {
  const BriPlaylistScreen({Key? key}) : super(key: key);

  @override
  State<BriPlaylistScreen> createState() => _BriPlaylistScreenState();
}

class _BriPlaylistScreenState extends State<BriPlaylistScreen> {
  int selectedCategory = 0;
  bool isPlaying = true;
  int _selectedIndex = 0; // 하단 네비게이션 상태

  final List<String> categories = ['경제', '문화', 'IT·과학', '스포츠', '재난·기후·환경'];
  final List<List<Map<String, String>>> initialArticlesByCategory = [
    [
      {
        'title': "'역대급 실적' SK하이닉스, 상반기 성과급 '150%' 지급",
        'reporter': '연합뉴스',
      },
      {
        'title': '민생 지원금 지급 시작... 국민들 기대감 높아',
        'reporter': 'JTBC 김하은 기자',
      },
    ],
    [
      {
        'title': '문화 기사1',
        'reporter': '문화기자',
      },
      {
        'title': '문화 기사2',
        'reporter': '문화기자',
      },
    ],
    [
      {
        'title': 'IT 기사1',
        'reporter': 'IT기자',
      },
      {
        'title': 'IT 기사2',
        'reporter': 'IT기자',
      },
    ],
    [
      {
        'title': '스포츠 기사1',
        'reporter': '스포츠기자',
      },
      {
        'title': '스포츠 기사2',
        'reporter': '스포츠기자',
      },
    ],
    [
      {
        'title': '재난 기사1',
        'reporter': '재난기자',
      },
      {
        'title': '재난 기사2',
        'reporter': '재난기자',
      },
    ],
  ];

  late List<List<Map<String, String>>> articlesByCategory;

  @override
  void initState() {
    super.initState();
    // articlesByCategory를 복사본으로 초기화
    articlesByCategory = initialArticlesByCategory
        .map((list) => List<Map<String, String>>.from(list))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final articles = articlesByCategory[selectedCategory];
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
                            // TODO: 홈스크린으로 이동
                            // Navigator.of(context).pushAndRemoveUntil(
                            //   MaterialPageRoute(builder: (context) => HomeScreen()),
                            //   (route) => false,
                            // );
                            Navigator.of(context).pop();
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
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '오늘의 뉴스',
                          style: TextStyle(
                            fontFamily: kPretendard,
                            fontWeight: FontWeight.w700,
                            fontSize: 29,
                            color: kBlue,
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
                      onTap: () => setState(() => selectedCategory = idx),
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
                  itemCount: articles.length,
                  buildDefaultDragHandles: false,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final item = articles.removeAt(oldIndex);
                      articles.insert(newIndex, item);
                    });
                  },
                  itemBuilder: (context, idx) {
                    final article = articles[idx];
                    return Column(
                      key: ValueKey(
                          'tile_${article['title']}_${article['reporter']}_$idx'),
                      children: [
                        Dismissible(
                          key: ValueKey(
                              'dismiss_${article['title']}_${article['reporter']}_$idx'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            color: Colors.redAccent,
                            child: const Icon(Icons.delete,
                                color: Colors.white, size: 28),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              articles.removeAt(idx);
                            });
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
                              child: const Center(
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
                              article['title']!,
                              style: const TextStyle(
                                fontFamily: kPretendard,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              article['reporter']!,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BriefingScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        if (idx < articles.length - 1)
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '현재\n뉴스\n사진',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: kPretendard),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '기사 제목',
                        style: TextStyle(
                          fontFamily: kPretendard,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: isPlaying ? 28 : 32,
                        color: Colors.black,
                      ),
                      onPressed: () => setState(() => isPlaying = !isPlaying),
                    ),
                  ],
                ),
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
          setState(() {
            _selectedIndex = index;
            // TODO: 각 탭별 화면 이동 구현 예정
          });
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
