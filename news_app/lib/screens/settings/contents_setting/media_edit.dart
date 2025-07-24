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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // 상단 바
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 24, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _cancel,
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF0565FF), size: 28),
                        SizedBox(width: 2),
                        Text('뒤로',
                            style: TextStyle(
                                color: Color(0xFF0565FF),
                                fontWeight: FontWeight.w600,
                                fontSize: 20)),
                      ],
                    ),
                  ),
                  const Text('언론사 설정',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  GestureDetector(
                    onTap: selectedIndexes.isNotEmpty ? _save : null,
                    child: Text(
                      '완료',
                      style: TextStyle(
                        color: selectedIndexes.isNotEmpty
                            ? const Color(0xFF0565FF)
                            : Colors.grey[400],
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // 언론사 선택 그리드
            Expanded(
              child: GridView.builder(
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
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
