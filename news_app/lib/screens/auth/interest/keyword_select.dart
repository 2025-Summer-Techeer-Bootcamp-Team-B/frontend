import 'package:flutter/material.dart';
// import '../../home/home_screen.dart';

class KeywordSelectPage extends StatefulWidget {
  const KeywordSelectPage({super.key});

  @override
  State<KeywordSelectPage> createState() => _KeywordSelectPageState();
}

class _KeywordSelectPageState extends State<KeywordSelectPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> keywords = [];
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isKeyboardVisible = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addKeyword(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty && !keywords.contains(trimmed) && keywords.length < 20) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                    suffixIcon: keywords.length < 20
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
                  '선택된 키워드 (${keywords.length}/20)',
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

              const Spacer(),

              // 완료 버튼
              Container(
                width: double.infinity,
                height: 56,
                margin: const EdgeInsets.only(bottom: 24),
                child: ElevatedButton(
                  // onPressed: keywords.isNotEmpty
                  //     ? () {
                  //         // 완료 처리 - 홈 화면으로 이동
                  //         Navigator.of(context).pushAndRemoveUntil(
                  //           MaterialPageRoute(
                  //             builder: (context) => const HomeScreen(),
                  //           ),
                  //           (route) => false, // 모든 이전 화면 제거
                  //         );
                  //       }
                  //     : null,
                  onPressed: null, // 홈 스크린으로 이동 비활성화

                  style: ElevatedButton.styleFrom(
                    backgroundColor: keywords.isNotEmpty
                        ? const Color(0xFF0565FF)
                        : Colors.grey[300],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: keywords.isNotEmpty ? 4 : 0,
                    shadowColor: keywords.isNotEmpty 
                        ? const Color(0xFF0565FF).withOpacity(0.3)
                        : null,
                  ),
                  child: Text(
                    '완료 (${keywords.length}/20)',
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
    );
  }
}
