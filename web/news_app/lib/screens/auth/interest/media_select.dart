import 'package:flutter/material.dart';

class MediaSelectPage extends StatefulWidget {
  const MediaSelectPage({super.key});

  @override
  State<MediaSelectPage> createState() => _MediaSelectPageState();
}

class _MediaSelectPageState extends State<MediaSelectPage> {
  final List<Map<String, String>> mediaList = [
    {'name': 'SBS', 'image': 'assets/a_image/sbs_news_logo.png'},
    {'name': '한국경제', 'image': 'assets/a_image/hkyungjae_news_logo.png'},
    {'name': '매일경제', 'image': 'assets/a_image/maeil_news_logo.png'},
  ];

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 파란색 < 화살표 (피그마 기준 위치/크기/컬러)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF0565FF),
                  size: 28,
                ),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                splashRadius: 24,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ),
            // 타이틀/설명/안내문구 (피그마 기준, 중앙 정렬)
            Padding(
              padding: const EdgeInsets.only(
                left: 32.0,
                right: 32.0,
                top: 16.0,
                bottom: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '관심있는 언론사를 선택해 주세요',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            height: 1.3,
                            color: Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '미선택 시 랜덤으로 선택됩니다',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF0565FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // 언론사 선택 그리드 (피그마 기준 네모/여백)
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 28,
                  crossAxisSpacing: 18,
                  childAspectRatio: 0.8,
                ),
                itemCount: mediaList.length,
                itemBuilder: (context, index) {
                  final media = mediaList[index];
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            PhysicalModel(
                              color: Colors.white,
                              elevation: 6,
                              shadowColor: Color(0x220565FF),
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
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0565FF),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(3),
                                  child: Icon(
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
                          style: TextStyle(
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
            // 하단 버튼(화살표+파란동그라미) 화면 중앙에 가깝게
            Padding(
              padding: const EdgeInsets.only(bottom: 264.0),
              child: Center(
                child: SizedBox(
                  width: 120,
                  height: 56,
                  child: PhysicalModel(
                    color: Colors.transparent,
                    elevation: 8,
                    shadowColor: Color(0x220565FF),
                    borderRadius: BorderRadius.circular(28),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0565FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // TODO: 선택 완료 처리
                      },
                      child: CustomPaint(
                        size: Size(40, 32),
                        painter: _LongArrowPainter(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LongArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 화살표 몸통
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width - 6, size.height / 2),
      paint,
    );
    // 화살표 머리 (몸통과 꼭 붙게)
    canvas.drawLine(
      Offset(size.width - 16, size.height / 2 - 8),
      Offset(size.width - 6, size.height / 2),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - 16, size.height / 2 + 8),
      Offset(size.width - 6, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
