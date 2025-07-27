import 'package:flutter/material.dart';
import 'keyword_select.dart';
import 'media_select.dart';
import '../../../models/category_model.dart';
import '../../../services/api_service.dart';

class CategorySelectPage extends StatefulWidget {
  final List<String> selectedMedia;
  
  const CategorySelectPage({
    super.key,
    required this.selectedMedia,
  });

  @override
  State<CategorySelectPage> createState() => _CategorySelectPageState();
}

class _CategorySelectPageState extends State<CategorySelectPage> {
  late List<String> availableCategories;
  final Set<int> selected = {};
  bool isUpdating = false; // 카테고리 업데이트 중 상태

  @override
  void initState() {
    super.initState();
    // 선택된 언론사들에 따라 사용 가능한 카테고리 목록을 가져옴
    availableCategories = CategoryModel.getAvailableCategories(widget.selectedMedia);
    
    // 기존에 저장된 카테고리 정보가 있다면 불러와서 선택 상태로 설정
    _loadSavedCategories();
  }

  // 저장된 카테고리 정보 불러오기
  Future<void> _loadSavedCategories() async {
    try {
      final apiService = ApiService();
      final savedCategories = await apiService.getUserCategories();
      
      // 저장된 카테고리와 현재 사용 가능한 카테고리를 비교하여 선택 상태 설정
      setState(() {
        for (int i = 0; i < availableCategories.length; i++) {
          if (savedCategories.categories.contains(availableCategories[i])) {
            selected.add(i);
          }
        }
      });
    } catch (e) {
      print('저장된 카테고리 불러오기 실패: $e');
      // 오류가 발생해도 계속 진행
    }
  }

  // 카테고리 선택 변경 시 API로 업데이트
  Future<void> _updateCategories() async {
    // 최소 3개 이상 선택되었을 때만 API 호출
    List<String> selectedCategories = selected
        .map((index) => availableCategories[index])
        .toList();
    
    if (selectedCategories.length < 3) return;
    
    setState(() {
      isUpdating = true;
    });
    
    try {
      final apiService = ApiService();
      final updatedCategories = await apiService.updateUserCategories(selectedCategories);
      print('카테고리 업데이트 성공: ${updatedCategories.categories}');
      
      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('카테고리가 업데이트되었습니다.'),
            backgroundColor: Color(0xFF0565FF),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('카테고리 업데이트 실패: $e');
      // 오류 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('카테고리 업데이트 실패: $e'),
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

  List<Widget> _buildCategoryGrid() {
    List<Widget> rows = [];
    int itemsPerRow = 3;
    
    for (int i = 0; i < availableCategories.length; i += itemsPerRow) {
      List<Widget> rowItems = [];
      
      for (int j = 0; j < itemsPerRow; j++) {
        int idx = i + j;
        if (idx >= availableCategories.length) {
          // 빈 공간 추가
          rowItems.add(const SizedBox(width: 96, height: 104));
        } else {
          final category = availableCategories[idx];
          final isSelected = selected.contains(idx);
          final iconSize = category.length > 5 ? 52.0 : 61.0;
          
          rowItems.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    if (isSelected) {
                      selected.remove(idx);
                    } else {
                      selected.add(idx);
                    }
                  });
                  
                  // 카테고리 선택이 변경될 때마다 API로 업데이트
                  await _updateCategories();
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
                      Image.asset(
                        CategoryModel.getCategoryImage(category),
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: category.length > 5 ? 13 : 15,
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
            ),
          );
        }
      }
      
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowItems,
          ),
        ),
      );
    }
    
    return rows;
  }

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
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.black, width: 1),
            // ),
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildCategoryGrid(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 최소 3개 선택 안내 텍스트 + 업데이트 상태
                Center(
                  child: Column(
                    children: [
                      Text(
                        '최소 3개 선택',
                        style: TextStyle(
                          color: const Color(0xFF0565FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      if (isUpdating) ...[
                        const SizedBox(height: 8),
                        Row(
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
                              '업데이트 중...',
                              style: TextStyle(
                                color: const Color(0xFF0565FF),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // 하단 다음 버튼
                Center(
                  child: GestureDetector(
                    onTap: selected.length >= 3
                        ? () {
                            // 선택된 카테고리들을 추출
                            List<String> selectedCategories = selected
                                .map((index) => availableCategories[index])
                                .toList();
                            
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => KeywordSelectPage(
                                  selectedMedia: widget.selectedMedia,
                                  selectedCategories: selectedCategories,
                                ),
                              ),
                            );
                          }
                        : null,
                    child: Container(
                      width: 120,
                      height: 48,
                      decoration: BoxDecoration(
                        color: selected.length >= 3
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
