import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/common_models.dart';

class CategoryEditPage extends StatefulWidget {
  final List<String> initialCategories;
  const CategoryEditPage({Key? key, this.initialCategories = const []}) : super(key: key);

  @override
  State<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  late List<String> categories;
  final List<String> availableCategories = [
    '경제', '정치', '사회', '국제', '문화', '스포츠', '연예', 'IT', '부동산', '증권'
  ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    categories = List<String>.from(widget.initialCategories);
    _loadUserCategories();
  }

  Future<void> _loadUserCategories() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final apiService = ApiService();
      await apiService.initialize();
      final userCategories = await apiService.getUserCategories();
      
      if (userCategories.categories != null && userCategories.categories!.isNotEmpty) {
        setState(() {
          categories = userCategories.categories!;
          _isLoading = false;
        });
        print('기존 사용자 카테고리 로드 완료: $categories');
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('기존 사용자 카테고리 로드 실패: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleCategory(String category) {
    setState(() {
      if (categories.contains(category)) {
        categories.remove(category);
      } else {
        categories.add(category);
      }
    });
  }

  void _saveCategories() async {
    try {
      final apiService = ApiService();
      await apiService.initialize();
      await apiService.updateUserCategories(categories);
      
      print('카테고리 업데이트 완료: $categories');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('카테고리가 저장되었습니다.'),
            backgroundColor: Color(0xFF0565FF),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('카테고리 업데이트 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('카테고리 저장에 실패했습니다: $e'),
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
        child: Column(
          children: [
            // 상단 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 24,
                          color: Color(0xFF0565FF),
                        ),
                        SizedBox(width: 2),
                        Text(
                          '뒤로',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0565FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _saveCategories,
                    child: const Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0565FF),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 제목
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '관심 카테고리 수정',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 설명
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '관심 있는 카테고리를 선택해 주세요',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Pretendard',
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 카테고리 그리드
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: availableCategories.length,
                        itemBuilder: (context, index) {
                          final category = availableCategories[index];
                          final isSelected = categories.contains(category);
                          
                          return GestureDetector(
                            onTap: () => _toggleCategory(category),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF0565FF) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF0565FF) : const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _getCategoryIcon(category),
                                    size: 32,
                                    color: isSelected ? Colors.white : const Color(0xFF0565FF),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Pretendard',
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '경제':
        return Icons.trending_up;
      case '정치':
        return Icons.account_balance;
      case '사회':
        return Icons.people;
      case '국제':
        return Icons.public;
      case '문화':
        return Icons.theater_comedy;
      case '스포츠':
        return Icons.sports_soccer;
      case '연예':
        return Icons.music_note;
      case 'IT':
        return Icons.computer;
      case '부동산':
        return Icons.home;
      case '증권':
        return Icons.show_chart;
      default:
        return Icons.category;
    }
  }
} 