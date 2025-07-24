import 'package:flutter/material.dart';

class MediaEditPage extends StatefulWidget {
  final List<String> initialMedias;
  const MediaEditPage({Key? key, this.initialMedias = const []})
      : super(key: key);

  @override
  State<MediaEditPage> createState() => _MediaEditPageState();
}

class _MediaEditPageState extends State<MediaEditPage> {
  final List<Map<String, String>> mediaList = [
    {'name': 'SBS', 'image': 'assets/a_image/sbs_news_logo.png'},
    {'name': '한국경제', 'image': 'assets/a_image/hkyungjae_news_logo.png'},
    {'name': '매일경제', 'image': 'assets/a_image/maeil_news_logo.png'},
    // ... 필요시 추가
  ];

  late Set<int> selectedIndexes;

  @override
  void initState() {
    super.initState();
    selectedIndexes = {};
    for (int i = 0; i < mediaList.length; i++) {
      if (widget.initialMedias.contains(mediaList[i]['name'])) {
        selectedIndexes.add(i);
      }
    }
  }

  void _toggleSelect(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
  }

  void _save() {
    final selectedMedias =
        selectedIndexes.map((i) => mediaList[i]['name']!).toList();
    Navigator.of(context).pop(selectedMedias);
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  void _goNext() {
    Navigator.of(context).pop(selectedIndexes.map((i) => mediaList[i]['name']!).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Center(
        child: Container(
          width: 393,
          height: 852,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
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
              // 상단 뒤로가기 (위에 고정)
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 32, bottom: 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _cancel,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0565FF), size: 28),
                        SizedBox(width: 2),
                        Text('뒤로', style: TextStyle(color: Color(0xFF0565FF), fontWeight: FontWeight.w600, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
              // 안내문구+그리드 묶음 중앙보다 약간 위쪽 배치
              Expanded(
                child: Align(
                  alignment: const Alignment(0, -0.3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 안내문구
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: const [
                            Text(
                              '원하는 언론사들을 선택해주세요',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF222222),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 6),
                            Text(
                              '미선택시 랜덤으로 추천해드립니다',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // 언론사 선택 그리드
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 28,
                          crossAxisSpacing: 18,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: mediaList.length,
                        itemBuilder: (context, index) {
                          final media = mediaList[index];
                          final isSelected = selectedIndexes.contains(index);
                          return GestureDetector(
                            onTap: () => _toggleSelect(index),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    PhysicalModel(
                                      color: isSelected
                                          ? const Color(0xFF0565FF).withOpacity(0.1)
                                          : Colors.white,
                                      elevation: 6,
                                      shadowColor: const Color(0x220565FF),
                                      borderRadius: BorderRadius.circular(18),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.asset(
                                          media['image']!,
                                          fit: BoxFit.fill,
                                          width: 80,
                                          height: 80,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF0565FF),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(3),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  media['name']!,
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Color(0xFF222222),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // 하단 화살표 버튼 (카드 맨 아래, pill 스타일, 약간 위로)
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0, top: 8.0),
                child: Center(
                  child: GestureDetector(
                    onTap: _goNext,
                    child: Container(
                      width: 120,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0565FF),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x220565FF),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.arrow_forward, color: Colors.white, size: 32),
                      ),
                    ),
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
