import 'package:flutter/material.dart';
import '../../../models/category_model.dart';
import '../../../services/api_service.dart';
import '../../../models/common_models.dart';
import '../display_setting/setting_screen.dart';

class CategoryEditPage extends StatefulWidget {
  const CategoryEditPage({super.key});

  @override
  State<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  late List<String> availableCategories;
  final Set<int> selected = {};
  bool isUpdating = false;
  bool isLoading = true; // 초기 로딩 상태
  List<String> currentCategories = []; // 현재 저장된 카테고리들

  @override
  void initState() {
    super.initState();
    // 모든 언론사의 카테고리를 표시 (category_select와 동일)
    availableCategories = CategoryModel.getAvailableCategories(['한국경제', 'SBS뉴스', '매일경제']);
    _loadSavedCategories();
  }

  // 저장된 카테고리 정보 불러오기 (언론사/키워드와 동일한 방식)
  Future<void> _loadSavedCategories() async {
    print('🔄 사용자 카테고리 불러오기 시작...');
    
    try {
      setState(() {
        isLoading = true;
      });
      
      final apiService = ApiService();
      await apiService.initialize();
      final userCategories = await apiService.getUserCategories();
      
      print('📦 API 응답: $userCategories');
      print('📦 API 응답 - category 필드: ${userCategories.category}');
      
      if (userCategories.category != null && userCategories.category!.isNotEmpty) {
        setState(() {
          currentCategories = userCategories.category!;
          selected.clear(); // 기존 선택 초기화
          
          // 저장된 카테고리들을 선택 상태로 설정
          for (int i = 0; i < availableCategories.length; i++) {
            final categoryName = availableCategories[i];
            if (userCategories.category!.contains(categoryName)) {
              selected.add(i);
              print('🎯 카테고리 선택됨: $categoryName (인덱스: $i)');
            } else {
              print('카테고리 매칭 실패: $categoryName');
            }
          }
          
          print('📊 선택된 인덱스: $selected');
          print('📋 현재 선택된 카테고리: ${selected.map((i) => availableCategories[i]).toList()}');
          isLoading = false;
        });
        print('✅ 기존 사용자 카테고리 로드 완료: ${userCategories.category}');
      } else {
        print('⚠️ API 응답이 비어있음');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ 저장된 카테고리 불러오기 실패: $e');
      setState(() {
        isLoading = false;
      });
      
      // 에러 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('저장된 카테고리 정보를 불러오는데 실패했습니다.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // 카테고리 선택 변경 시 API로 업데이트 (언론사/키워드와 동일한 방식)
  Future<void> _updateCategories() async {
    // 최소 3개 이상 선택되었을 때만 처리
    List<String> selectedCategories = selected
        .map((index) => availableCategories[index])
        .toList();
    
    if (selectedCategories.length < 3) return;
    
    setState(() {
      isUpdating = true;
    });
    
    try {
      final apiService = ApiService();
      await apiService.updateUserCategories(selectedCategories);
      
      print('✅ 카테고리 선택 완료: $selectedCategories');
      

    } catch (e) {
      print('❌ 카테고리 업데이트 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('카테고리 업데이트에 실패했습니다.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
    
    if (mounted) {
      setState(() {
        isUpdating = false;
      });
    }
  }

  // 변경사항이 있는지 확인
  bool get hasChanges {
    List<String> selectedCategories = selected
        .map((index) => availableCategories[index])
        .toList();
    
    if (selectedCategories.length != currentCategories.length) return true;
    
    for (String category in selectedCategories) {
      if (!currentCategories.contains(category)) return true;
    }
    
    return false;
  }

  // category_select와 완전히 동일한 그리드 빌드 함수
  List<Widget> _buildCategoryGrid() {
    List<Widget> rows = [];
    int itemsPerRow = 3;
    
    for (int i = 0; i < availableCategories.length; i += itemsPerRow) {
      List<Widget> rowItems = [];
      
      for (int j = 0; j < itemsPerRow; j++) {
        int idx = i + j;
        if (idx >= availableCategories.length) {
          // 마지막 행이 아니면 빈 공간 추가
          if (i + itemsPerRow < availableCategories.length) {
            rowItems.add(const SizedBox(width: 96, height: 104));
          }
        } else {
          final category = availableCategories[idx];
          final isSelected = selected.contains(idx);
          final iconSize = 52.0; // 모든 아이콘을 동일한 크기로 설정
          
          rowItems.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: isLoading ? null : () async {
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
                child: Opacity(
                  opacity: isLoading ? 0.6 : 1.0,
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
            ),
          );
        }
      }
      
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: rowItems.length == 1 
                ? MainAxisAlignment.center  // 마지막 행에 아이템이 1개면 중앙 정렬
                : rowItems.length == 2
                    ? MainAxisAlignment.spaceEvenly  // 2개면 균등 분배
                    : MainAxisAlignment.center,
            children: rowItems,
          ),
        ),
      );
    }
    
    return rows;
  }

  // 완료 버튼 클릭 시 저장하고 설정 화면으로 돌아가기
  void _saveAndGoBack() async {
    if (selected.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 3개 이상 선택해주세요.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    List<String> selectedCategories = selected
        .map((index) => availableCategories[index])
        .toList();

    setState(() {
      isUpdating = true;
    });

    try {
      final apiService = ApiService();
      await apiService.updateUserCategories(selectedCategories);

      if (mounted) {
        // 설정 화면으로 바로 돌아가기
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SettingScreen(),
          ),
        );
      }
    } catch (e) {
      print('카테고리 저장 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('카테고리 저장에 실패했습니다.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        isUpdating = false;
      });
    }
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
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 상단 < 아이콘 + 안내문구 한 줄 배치 (category_select와 완전히 동일)
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
                // 카드 리스트를 Expanded로 감싸기 (category_select와 동일)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildCategoryGrid(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 카테고리 선택 상태 정보 표시
                Center(
                  child: Column(
                    children: [
                      if (isLoading) ...[
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
                              '저장된 카테고리 불러오는 중...',
                              style: TextStyle(
                                color: const Color(0xFF0565FF),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Text(
                          '현재 ${selected.length}개 선택됨 (최소 3개)',
                          style: TextStyle(
                            color: selected.length >= 3 ? const Color(0xFF0565FF) : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        if (currentCategories.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '기존: ${currentCategories.join(', ')}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Pretendard',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // 하단 완료 버튼 (category_select와 완전히 동일한 스타일)
                Center(
                  child: GestureDetector(
                    onTap: (selected.length >= 3 && hasChanges && !isUpdating && !isLoading)
                        ? _saveAndGoBack
                        : null,
                    child: Container(
                      width: 120,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (selected.length >= 3 && hasChanges && !isUpdating && !isLoading)
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