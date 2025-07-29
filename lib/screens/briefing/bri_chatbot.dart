import 'package:flutter/material.dart';
import '../../services/chat_service.dart';
import '../../models/chat_message_model.dart';
import '../../models/common_models.dart';

class BriChatBotScreen extends StatefulWidget {
  final String? articleId;
  
  const BriChatBotScreen({Key? key, this.articleId}) : super(key: key);

  @override
  State<BriChatBotScreen> createState() => _BriChatBotScreenState();
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}

class _BriChatBotScreenState extends State<BriChatBotScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<_ChatMessage> _messages = [
    _ChatMessage(text: "안녕하세요! 궁금한 점이 있으면 언제든 물어보세요.", isUser: false),
  ];
  
  // ChatService 인스턴스 추가
  final ChatService _chatService = ChatService();
  String? _conversationId;
  bool _isLoading = false;
  
  // 기사 ID (외부에서 설정)
  String? _articleId;

  late AnimationController _titleAnimationController;
  late Animation<Offset> _titleAnimation;
  bool shouldAnimate = false;
  final String articleTitle = "'역대급 실적' SK하이닉스, 상반기 성과급 '150%' 지급";

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _controller.clear();
      _isLoading = true;
    });

    try {
      ChatResponse chatResponse;
      if (_conversationId == null) {
        // 새로운 대화 시작 (기사 ID 포함)
        chatResponse = await _chatService.startNewConversation(text, articleId: _articleId);
        _conversationId = _chatService.currentConversationId;
      } else {
        // 기존 대화에 메시지 추가 (기사 ID 포함)
        chatResponse = await _chatService.sendMessage(text, articleId: _articleId);
      }
      
      setState(() {
        _messages.add(_ChatMessage(text: chatResponse.response, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(text: "죄송합니다. 오류가 발생했습니다: $e", isUser: false));
        _isLoading = false;
      });
      print('챗봇 API 에러: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    
    // 기사 ID 설정
    _articleId = widget.articleId;
    
    _titleAnimationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _titleAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-0.3, 0),
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.linear,
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (articleTitle.length > 14) {
        setState(() {
          shouldAnimate = true;
        });
        _titleAnimationController.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null &&
                details.primaryVelocity! > 0) {
              Navigator.of(context).pop();
            }
          },
          child: Center(
            child: Container(
              width: 393,
              height: 852,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 기사 정보 캡션 영역
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 기사 사진 (placeholder)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/a_image/SKhynix.jpg',
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 카테고리 + 제목
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0565FF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  '경제',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ClipRect(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    height: 24,
                                    width: MediaQuery.of(context).size.width -
                                        64 -
                                        24 -
                                        24 -
                                        12, // 전체 - 사진 - 좌우패딩 - 여백
                                    child: shouldAnimate
                                        ? SlideTransition(
                                            position: _titleAnimation,
                                            child: Text(
                                              articleTitle,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontFamily: 'Pretendard',
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        : Text(
                                            articleTitle,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontFamily: 'Pretendard',
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 구분선 추가
                  const Divider(
                    color: Color(0xFFE5E8EB),
                    thickness: 1,
                    height: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  // 채팅 메시지 영역
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return Align(
                          alignment: msg.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            constraints: const BoxConstraints(maxWidth: 260),
                            decoration: BoxDecoration(
                              color: msg.isUser
                                  ? const Color(0xFF0565FF)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(18),
                                topRight: const Radius.circular(18),
                                bottomLeft:
                                    Radius.circular(msg.isUser ? 18 : 4),
                                bottomRight:
                                    Radius.circular(msg.isUser ? 4 : 18),
                              ),
                              boxShadow: [
                                if (!msg.isUser)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                color:
                                    msg.isUser ? Colors.white : Colors.black87,
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // 입력창
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border:
                                  Border.all(color: const Color(0xFFE5E8EB)),
                            ),
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              decoration: const InputDecoration(
                                hintText: "질문을 보내주세요",
                                hintStyle: TextStyle(
                                  color: Color(0xFFB0B8C1),
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0565FF),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x220565FF),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
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

  @override
  void dispose() {
    _titleAnimationController.dispose();
    super.dispose();
  }
}
