import 'package:flutter/material.dart';
import 'category_select.dart';
import '../../../models/category_model.dart';
import '../../../services/api_service.dart';

class MediaSelectPage extends StatefulWidget {
  const MediaSelectPage({super.key});

  @override
  State<MediaSelectPage> createState() => _MediaSelectPageState();
}

class _MediaSelectPageState extends State<MediaSelectPage> {
  final List<Map<String, String>> mediaList = [
    {'name': 'SBS뉴스', 'image': 'assets/a_image/sbs_news_logo.png'},
    {'name': '한국경제', 'image': 'assets/a_image/hkyungjae_news_logo.png'},
    {'name': '매일경제', 'image': 'assets/a_image/maeil_news_logo.png'},
  ];

  int? selectedIndex;
  final Set<int> selected = {};
  bool isUpdating = false; // 언론사 업데이트 중 상태

  @override
  void initState() {
    super.initState();
    // 기존에 저장된 언론사 정보가 있다면 불러와서 선택 상태로 설정
    _loadSavedPress();
  }

  // 저장된 언론사 정보 불러오기
  Future<void> _loadSavedPress() async {
    try {
      final apiService = ApiService();
      final savedPress = await apiService.getUserPress();
      
      // 저장된 언론사와 현재 언론사 목록을 비교하여 선택 상태 설정
      setState(() {
        for (int i = 0; i < mediaList.length; i++) {
          if (savedPress.pressList.contains(mediaList[i]['name'])) {
            selected.add(i);
          }
        }
      });
    } catch (e) {
      print('저장된 언론사 불러오기 실패: $e');
      // 오류가 발생해도 계속 진행
    }
  }

  // 언론사 선택 변경 시 API로 업데이트
  Future<void> _updatePress() async {
    // 최소 1개 이상 선택되었을 때만 API 호출
    List<String> selectedPress = selected
        .map((index) => mediaList[index]['name']!)
        .toList();
    
    if (selectedPress.isEmpty) return;
    
    print('언론사 업데이트 시작: $selectedPress');
    
    setState(() {
      isUpdating = true;
    });
    
    try {
      final apiService = ApiService();
      print('API 서비스 호출 중...');
      final updatedPress = await apiService.updateUserPress(selectedPress);
      print('언론사 업데이트 성공: ${updatedPress.pressList}');
      
      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('언론사가 업데이트되었습니다.'),
            backgroundColor: Color(0xFF0565FF),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('언론사 업데이트 실패: $e');
      // 오류 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('언론사 업데이트 실패: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isUpdating = false;
        });
      }
    }
  }

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
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF0565FF),
                  size: 28,
                ),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                splashRadius: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            // 타이틀/설명/안내문구 (피그마 기준, 중앙 정렬)
            const Padding(
              padding: EdgeInsets.only(
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
                        SizedBox(height: 6),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 28,
                  crossAxisSpacing: 18,
                  childAspectRatio: 0.8,
                ),
                itemCount: mediaList.length,
                itemBuilder: (context, index) {
                  final media = mediaList[index];
                  final isSelected = selected.contains(index);
                  return GestureDetector(
                                      onTap: () async {
                    setState(() {
                      if (isSelected) {
                        selected.remove(index);
                      } else {
                        selected.add(index);
                      }
                    });
                    
                    // 언론사 선택이 변경될 때마다 API로 업데이트
                    await _updatePress();
                  },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            PhysicalModel(
                              color: Colors.white,
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
            // 업데이트 상태 표시
            if (isUpdating)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0565FF)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '언론사 업데이트 중...',
                        style: TextStyle(
                          color: const Color(0xFF0565FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // 하단 버튼(화살표+파란동그라미) 화면 중앙에 가깝게
            Padding(
              padding: EdgeInsets.only(bottom: isUpdating ? 200.0 : 264.0),
              child: Center(
                child: SizedBox(
                  width: 120,
                  height: 56,
                  child: PhysicalModel(
                    color: Colors.transparent,
                    elevation: 8,
                    shadowColor: const Color(0x220565FF),
                    borderRadius: BorderRadius.circular(28),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selected.isNotEmpty
                            ? const Color(0xFF0565FF)
                            : const Color(0xFFE0E0E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      onPressed: selected.isNotEmpty
                          ? () {
                              // 선택된 언론사들의 이름을 추출
                              List<String> selectedMediaNames = selected
                                  .map((index) => mediaList[index]['name']!)
                                  .toList();
                              
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CategorySelectPage(
                                    selectedMedia: selectedMediaNames,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: CustomPaint(
                        size: const Size(40, 32),
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
