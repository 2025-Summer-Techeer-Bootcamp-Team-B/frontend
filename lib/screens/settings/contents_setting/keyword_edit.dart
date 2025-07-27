import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    keywords = List<String>.from(widget.initialKeywords);
    // 페이지 진입 시 자동으로 키워드 입력란에 포커스
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
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
    // 엔터/리턴 시 키보드 내리기
    _focusNode.unfocus();
  }

  void _saveKeywords() {
    Navigator.of(context).pop(keywords);
  }

  void _cancelAndPop() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 커스텀 상단바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _cancelAndPop,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0565FF), size: 28),
                        SizedBox(width: 2),
                        Text('뒤로', style: TextStyle(color: Color(0xFF0565FF), fontWeight: FontWeight.w600, fontSize: 20)),
                      ],
                    ),
                  ),
                  const Text('키워드 설정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  GestureDetector(
                    onTap: keywords.isNotEmpty ? _saveKeywords : null,
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      '완료',
                      style: TextStyle(
                        color: keywords.isNotEmpty ? const Color(0xFF0565FF) : Colors.grey[400],
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: _handleSubmit,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: '키워드를 입력하세요 (최대 $maxKeywords개)',
                      suffixIcon: keywords.length < maxKeywords
                          ? IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Color(0xFF0565FF)),
                              onPressed: () => _addKeyword(_controller.text),
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: _focusNode.hasFocus ? const Color(0xFF0565FF) : Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (keywords.isNotEmpty) ...[
                    Text('선택된 키워드 (${keywords.length}/$maxKeywords)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey[700])),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 80),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: keywords.map((keyword) {
                          return Chip(
                            label: Text(keyword, style: const TextStyle(color: Color(0xFF0565FF), fontWeight: FontWeight.w600)),
                            backgroundColor: const Color(0xFF0565FF).withOpacity(0.1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            deleteIcon: const Icon(Icons.close, size: 16, color: Color(0xFF0565FF)),
                            onDeleted: () => _removeKeyword(keyword),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Spacer(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
