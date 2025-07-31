import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/common_models.dart';

class KeywordEditPage extends StatefulWidget {
  final List<String> initialKeywords;
  const KeywordEditPage({Key? key, this.initialKeywords = const []}) : super(key: key);

  @override
  State<KeywordEditPage> createState() => _KeywordEditPageState();
}

class _KeywordEditPageState extends State<KeywordEditPage> {
  late List<String> keywords;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  static const int maxKeywords = 20;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    keywords = List<String>.from(widget.initialKeywords);
    _loadUserKeywords();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
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

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addKeyword(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty && !keywords.contains(trimmed) && keywords.length < maxKeywords) {
      setState(() {
        keywords.add(trimmed);
      });
      _controller.clear();
      _focusNode.unfocus();
    }
  }

  void _removeKeyword(String keyword) {
    setState(() {
      keywords.remove(keyword);
    });
  }

  void _handleSubmit(String value) {
    if (value.trim().isNotEmpty) {
      _addKeyword(value);
    }
    _focusNode.unfocus();
  }

  void _saveKeywords() async {
    try {
      final apiService = ApiService();
      await apiService.initialize();
      await apiService.updateUserKeywords(keywords);
      
      print('키워드 업데이트 완료: $keywords');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('키워드가 저장되었습니다.'),
            backgroundColor: Color(0xFF0565FF),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true); // 변경 사항을 전달
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
        child: Column(
          children: [
            // 헤더
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
                    '관심 키워드 수정',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: keywords.isNotEmpty ? _saveKeywords : null,
                    child: Text(
                      '완료',
                      style: TextStyle(
                        color: keywords.isNotEmpty 
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
            
            // 메인 콘텐츠
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      '최대 $maxKeywords개까지 입력 가능합니다',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 입력창
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    suffixIcon: keywords.length < maxKeywords
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
                              if (keywords.isNotEmpty) ...[
                                Text(
                                  '선택된 키워드 (${keywords.length}/$maxKeywords)',
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
                                    children: keywords.map((keyword) {
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
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
