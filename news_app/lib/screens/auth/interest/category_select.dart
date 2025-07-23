import 'package:flutter/material.dart';

class CategorySelectPage extends StatefulWidget {
  const CategorySelectPage({super.key});

  @override
  State<CategorySelectPage> createState() => _CategorySelectPageState();
}

class _CategorySelectPageState extends State<CategorySelectPage> {
  final List<Map<String, String>> categories = [
    {'name': '정치', 'image': 'assets/a_image/politics_icon.webp'},
    {'name': '경제', 'image': 'assets/a_image/economy.png'},
    {'name': '사회', 'image': 'assets/a_image/society_icon.webp'},
    {'name': '문화', 'image': 'assets/a_image/culture_icon.webp'},
    {'name': 'IT·과학', 'image': 'assets/a_image/IT_icon.webp'},
    {'name': '국제', 'image': 'assets/a_image/global_icon.png'},
    {'name': '재난·기후·환경', 'image': 'assets/a_image/environment_icon.webp'},
    {'name': '생활·건강', 'image': 'assets/a_image/health_icon.webp'},
    {'name': '스포츠', 'image': 'assets/a_image/sport_icon.png'},
    {'name': '연예', 'image': 'assets/a_image/entertainment.webp'},
    {'name': '날씨', 'image': 'assets/a_image/ weather_icon.png'},
    {'name': '이슈', 'image': 'assets/a_image/issue_icon.webp'},
  ];
  final Set<int> selected = {};

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 393,
            height: deviceHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 상단 < 아이콘 + 안내문구 한 줄 배치
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 32, bottom: 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        behavior: HitTestBehavior.opaque,
                        child: const Icon(Icons.chevron_left,
                            color: Color(0xFF0565FF), size: 28),
                      ),
                      const Spacer(),
                      const Text(
                        '관심있는 분야들을 선택해주세요.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // 카드 리스트를 Expanded로 감싸기
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (rowIdx) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (colIdx) {
                            int idx = rowIdx * 3 + colIdx;
                            if (idx >= categories.length)
                              return const SizedBox.shrink();
                            final isSelected = selected.contains(idx);
                            // 정치(0), 문화(3), IT·과학(4), 생활·건강(7), 연예(9)만 아이콘 크기 61
                            final bigIconIdx = [0, 3, 4, 7, 9];
                            final iconSize =
                                bigIconIdx.contains(idx) ? 61.0 : 52.0;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selected.remove(idx);
                                    } else {
                                      selected.add(idx);
                                    }
                                  });
                                },
                                child: Container(
                                  width: 96,
                                  height: 104,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: isSelected
                                        ? Border.all(
                                            color: const Color(0xFF0565FF),
                                            width: 2)
                                        : null,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      categories[idx]['image']!.isNotEmpty
                                          ? Image.asset(
                                              categories[idx]['image']!,
                                              width: iconSize,
                                              height: iconSize,
                                              fit: BoxFit.contain,
                                            )
                                          : Icon(Icons.image,
                                              size: iconSize,
                                              color: Colors.grey),
                                      const SizedBox(height: 6),
                                      Text(
                                        categories[idx]['name']!,
                                        style: TextStyle(
                                          fontSize:
                                              categories[idx]['name']!.length >
                                                      5
                                                  ? 13
                                                  : 15,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? const Color(0xFF0565FF)
                                              : Colors.black,
                                          fontFamily: 'Pretendard',
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                // 하단 다음 버튼
                Center(
                  child: GestureDetector(
                    onTap: selected.isNotEmpty ? () {} : null,
                    child: Container(
                      width: 120,
                      height: 48,
                      decoration: BoxDecoration(
                        color: selected.isNotEmpty
                            ? const Color(0xFF0565FF)
                            : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x220565FF),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 32,
                          weight: 800,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
