import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/common_models.dart';

class MediaEditPage extends StatefulWidget {
  final List<String> initialMedias;
  const MediaEditPage({Key? key, this.initialMedias = const []})
      : super(key: key);

  @override
  State<MediaEditPage> createState() => _MediaEditPageState();
}

class _MediaEditPageState extends State<MediaEditPage> {
  final List<Map<String, String>> mediaList = [
    {'name': 'SBS뉴스', 'image': 'assets/a_image/sbs_news_logo.png'},
    {'name': '한국경제', 'image': 'assets/a_image/hkyungjae_news_logo.png'},
    {'name': '매일경제', 'image': 'assets/a_image/maeil_news_logo.png'},
  ];

  late Set<int> selectedIndexes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedIndexes = {};
    // 기존 사용자 언론사 로드
    _loadUserPress();
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
      print('변경 후 선택된 인덱스들: $selectedIndexes');
      print('변경 후 선택된 언론사들: ${selectedIndexes.map((i) => mediaList[i]['name']).toList()}');
    });
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
      
      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('언론사가 저장되었습니다.'),
            backgroundColor: Color(0xFF0565FF),
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      Navigator.of(context).pop();
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
            // 상단 헤더
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF0565FF), size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 2),
                  const Text(
                    '뒤로',
                    style: TextStyle(
                      color: Color(0xFF0565FF),
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    '관심 언론사 수정',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: selectedIndexes.isNotEmpty ? _save : null,
                    child: Text(
                      '완료',
                      style: TextStyle(
                        color: selectedIndexes.isNotEmpty
                            ? const Color(0xFF0565FF)
                            : Colors.grey,
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
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
                    behavior: HitTestBehavior.opaque,
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
          ],
        ),
      ),
    );
  }
}
