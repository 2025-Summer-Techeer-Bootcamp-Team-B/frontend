import 'package:flutter/material.dart';

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

  final List<String> categories = ['정치', '문화', 'IT·과학', '스포츠', '재난·기후·환경'];
  final List<List<Map<String, String>>> initialArticlesByCategory = [
    [
      {
        'title': "'케이팝 데몬 헌터스' OST, 빌보드 싱글 7위",
        'reporter': 'JTBC 김하은 기자',
      },
      {
        'title': '여야, 경찰개혁 공청회서 격돌',
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
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios_new,
                        color: kBlue, size: 28),
                    const SizedBox(width: 8),
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
              ),
              const SizedBox(height: 14), // 카테고리 버튼 위 간격
              // 카테고리 탭
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, idx) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = idx),
                      child: _CategoryButton(
                        label: categories[idx],
                        selected: selectedCategory == idx,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12), // 카테고리 버튼 아래 간격
              // 카테고리 아래 검은 구분선
              Divider(
                height: 1,
                thickness: 1,
                color: const Color(0xFF222222).withOpacity(0.12),
              ),
              // 기사 리스트
              Expanded(
                child: ReorderableListView.builder(
                  key: ValueKey(selectedCategory),
                  buildDefaultDragHandles: false,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: articles.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final moved = articles.removeAt(oldIndex);
                      articles.insert(newIndex, moved);
                    });
                  },
                  itemBuilder: (context, idx) {
                    final article = articles[idx];
                    return Dismissible(
                      key: ValueKey(article['title']! +
                          article['reporter']! +
                          idx.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        color: Colors.redAccent,
                        child: const Icon(Icons.delete,
                            color: Colors.white, size: 28),
                      ),
                      onDismissed: (_) {
                        setState(() {
                          articles.removeAt(idx);
                        });
                      },
                      child: ListTile(
                        key: ValueKey(
                            'tile_${article['title']}_${article['reporter']}_$idx'),
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
                          child: const Icon(Icons.menu, color: Colors.black54),
                        ),
                      ),
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
              // 하단 네비게이션
              Container(
                height: 72,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF5F6F8), Color(0xFFE9EBF0)],
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavItem(
                      iconPath: 'assets/a_image/pl_setting_icon.png',
                      label: '설정',
                    ),
                    _NavItem(
                      iconPath: 'assets/a_image/pl_star_icon.png',
                      label: '즐겨찾기',
                    ),
                    _NavItem(
                      iconPath: 'assets/a_image/pl_history_icon.png',
                      label: '재생 기록',
                    ),
                  ],
                ),
              ),
            ],
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
