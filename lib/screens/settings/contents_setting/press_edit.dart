import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/common_models.dart';

class PressEditPage extends StatefulWidget {
  final List<String> initialPress;
  const PressEditPage({Key? key, this.initialPress = const []})
      : super(key: key);

  @override
  State<PressEditPage> createState() => _PressEditPageState();
}

class _PressEditPageState extends State<PressEditPage>
    with TickerProviderStateMixin {
  final List<Map<String, String>> mediaList = [
    {'name': 'SBS뉴스', 'image': 'assets/a_image/sbs_news_logo.png'},
    {'name': '한국경제', 'image': 'assets/a_image/hkyungjae_news_logo.png'},
    {'name': '매일경제', 'image': 'assets/a_image/maeil_news_logo.png'},
  ];

  late Set<int> selectedIndexes;
  late Set<int> currentSelectedIndexes;
  bool hasChanges = false;
  bool _isLoading = false;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    selectedIndexes = {};
    currentSelectedIndexes = {};
    
    // 애니메이션 초기화
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();

    // 기존 사용자 언론사 로드
    _loadUserPress();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // 기존 사용자 언론사 로드
  Future<void> _loadUserPress() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      print('언론사 로드 시작 - 사용 가능한 언론사: ${mediaList.map((m) => m['name']).toList()}');
      
      final apiService = ApiService();
      await apiService.initialize();
      final userPress = await apiService.getUserPress();
      
      print('API 응답 - userPress: $userPress');
      print('API 응답 - press 필드: ${userPress.press}');
      
      if (userPress.press != null && userPress.press!.isNotEmpty) {
        setState(() {
          // 기존 선택된 언론사들을 selectedIndexes에 추가
          for (int i = 0; i < mediaList.length; i++) {
            final mediaName = mediaList[i]['name']!;
            if (userPress.press!.contains(mediaName)) {
              selectedIndexes.add(i);
              currentSelectedIndexes.add(i);
              print('언론사 매칭 성공: $mediaName (인덱스: $i)');
            } else {
              print('언론사 매칭 실패: $mediaName');
            }
          }
          _isLoading = false;
        });
        print('기존 사용자 언론사 로드 완료: ${userPress.press}');
        print('선택된 인덱스: $selectedIndexes');
      } else {
        print('API 응답이 비어있음');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('기존 사용자 언론사 로드 실패: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleSelect(int index) {
    print('=== 언론사 클릭 이벤트 ===');
    print('클릭된 인덱스: $index');
    print('클릭된 언론사: ${mediaList[index]}');
    print('현재 선택된 인덱스들: $selectedIndexes');
    
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
        print('언론사 선택 해제: ${mediaList[index]['name']} (인덱스: $index)');
      } else {
        selectedIndexes.add(index);
        print('언론사 선택: ${mediaList[index]['name']} (인덱스: $index)');
      }
      hasChanges = !_areSetsEqual(selectedIndexes, currentSelectedIndexes);
      print('변경 후 선택된 인덱스들: $selectedIndexes');
      print('변경 후 선택된 언론사들: ${selectedIndexes.map((i) => mediaList[i]['name']).toList()}');
    });
  }

  bool _areSetsEqual(Set<int> set1, Set<int> set2) {
    if (set1.length != set2.length) return false;
    for (int item in set1) {
      if (!set2.contains(item)) return false;
    }
    return true;
  }

  void _save() async {
    try {
      final selectedMedias = selectedIndexes.map((i) => mediaList[i]['name']!).toList();
      
      print('언론사 저장 시작 - 선택된 인덱스: $selectedIndexes');
      print('언론사 저장 시작 - 선택된 언론사: $selectedMedias');
      
      final apiService = ApiService();
      await apiService.initialize();
      await apiService.updateUserPress(selectedMedias);
      
      print('언론사 업데이트 완료: $selectedMedias');
      
      // 저장 완료 다이얼로그 표시
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text('저장 완료'),
              ],
            ),
            content: Text(
              '언론사가 성공적으로 저장되었습니다.',
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  Navigator.of(context).pop(); // 설정 화면으로 돌아가기
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('언론사 업데이트 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('언론사 저장에 실패했습니다: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
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
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : GridView.builder(
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
                      final isSelected = selectedIndexes.contains(index);
                      return GestureDetector(
                        onTap: () => _toggleSelect(index),
                        behavior: HitTestBehavior.opaque,
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
                                      errorBuilder: (context, error, stackTrace) {
                                        print('이미지 로드 실패: ${media['name']} - $error');
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(18),
                                          ),
                                          child: Icon(
                                            Icons.image,
                                            size: 40,
                                            color: Colors.grey[400],
                                          ),
                                        );
                                      },
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
                        shadowColor: const Color(0x220565FF),
                        borderRadius: BorderRadius.circular(28),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasChanges
                                ? const Color(0xFF0565FF)
                                : const Color(0xFFE0E0E0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          onPressed: hasChanges ? _save : null,
                          child: hasChanges
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 32,
                                  weight: 800,
                                )
                              : const Icon(
                                  Icons.check,
                                  color: Colors.grey,
                                  size: 32,
                                  weight: 800,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
