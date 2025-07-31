import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/common_models.dart';

class KeywordEditPage extends StatefulWidget {
  final List<String> initialKeywords;
  const KeywordEditPage({Key? key, this.initialKeywords = const []}) : super(key: key);

  @override
  State<KeywordEditPage> createState() => _KeywordEditPageState();
}

class _KeywordEditPageState extends State<KeywordEditPage>
    with TickerProviderStateMixin {
  late List<String> keywords;
  late List<String> selectedKeywords;
  bool hasChanges = false;
  
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isKeyboardVisible = false;
  bool _isLoading = false;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    keywords = List<String>.from(widget.initialKeywords);
    selectedKeywords = List<String>.from(widget.initialKeywords);
    
    _focusNode.addListener(() {
      setState(() {
        isKeyboardVisible = _focusNode.hasFocus;
      });
    });
    
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

    _loadUserKeywords();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadUserKeywords() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final apiService = ApiService();
      await apiService.initialize();
      final userKeywords = await apiService.getUserKeywords();
      
      if (userKeywords.keywords != null && userKeywords.keywords!.isNotEmpty) {
        setState(() {
          keywords = userKeywords.keywords!;
          selectedKeywords = List<String>.from(userKeywords.keywords!);
          _isLoading = false;
        });
        print('기존 사용자 키워드 로드 완료: $keywords');
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('기존 사용자 키워드 로드 실패: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addKeyword(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty &&
        !selectedKeywords.contains(trimmed) &&
        selectedKeywords.length < 20) {
      setState(() {
        selectedKeywords.add(trimmed);
        hasChanges = !_areListsEqual(keywords, selectedKeywords);
      });
      _controller.clear();
      _focusNode.unfocus();
    }
  }

  void _removeKeyword(String keyword) {
    setState(() {
      selectedKeywords.remove(keyword);
      hasChanges = !_areListsEqual(keywords, selectedKeywords);
    });
  }

  void _handleSubmit(String value) {
    if (value.trim().isNotEmpty) {
      _addKeyword(value);
    }
  }

  bool _areListsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  void _saveKeywords() async {
    try {
      final apiService = ApiService();
      await apiService.initialize();
      await apiService.updateUserKeywords(selectedKeywords);
      
      print('키워드 업데이트 완료: $selectedKeywords');
      
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
              '키워드가 성공적으로 저장되었습니다.',
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
      print('키워드 업데이트 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('키워드 저장에 실패했습니다: $e'),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤더
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF0565FF),
                          size: 24,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 48), // 균형 맞추기
                    ],
                  ),

                  const SizedBox(height: 32),

                  // 제목
                  const Text(
                    '관심 있는 키워드를\n입력해 주세요',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.black,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 설명
                  Text(
                    '최대 20개까지 입력 가능합니다',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 입력창
                  if (!_isLoading) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _focusNode.hasFocus
                              ? const Color(0xFF0565FF)
                              : Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onSubmitted: _handleSubmit,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '예: AI, 주식, 부동산, 건강...',
                          hintStyle: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          border: InputBorder.none,
                          suffixIcon: selectedKeywords.length < 20
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Color(0xFF0565FF),
                                    size: 24,
                                  ),
                                  onPressed: () => _addKeyword(_controller.text),
                                )
                              : null,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 키워드 목록
                    if (selectedKeywords.isNotEmpty) ...[
                      Text(
                        '선택된 키워드 (${selectedKeywords.length}/20)',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 80),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedKeywords.map((keyword) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0565FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF0565FF).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    keyword,
                                    style: const TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color(0xFF0565FF),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () => _removeKeyword(keyword),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Color(0xFF0565FF),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ] else ...[
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],

                  const Spacer(),

                  // 완료 버튼
                  Container(
                    width: double.infinity,
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 24),
                    child: ElevatedButton(
                      onPressed: hasChanges ? _saveKeywords : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasChanges ? const Color(0xFF0565FF) : Colors.grey[300],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: hasChanges ? 4 : 0,
                        shadowColor: hasChanges ? const Color(0xFF0565FF).withOpacity(0.3) : null,
                      ),
                      child: Text(
                        hasChanges ? '완료 (${selectedKeywords.length}/20)' : '변경사항 없음',
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
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
