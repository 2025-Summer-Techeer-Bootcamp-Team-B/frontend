import 'package:flutter/material.dart';
import '../../services/chat_service.dart';
import '../../services/api_service.dart';
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

// 로딩 애니메이션 위젯
class _LoadingAnimation extends StatelessWidget {
  final Animation<double> dot1Animation;
  final Animation<double> dot2Animation;
  final Animation<double> dot3Animation;

  const _LoadingAnimation({
    required this.dot1Animation,
    required this.dot2Animation,
    required this.dot3Animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: dot1Animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(dot1Animation),
            const SizedBox(width: 4),
            _buildDot(dot2Animation),
            const SizedBox(width: 4),
            _buildDot(dot3Animation),
          ],
        );
      },
    );
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -8 * animation.value),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF0565FF),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

class _BriChatBotScreenState extends State<BriChatBotScreen>
    with TickerProviderStateMixin {
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
  
  // 로딩 애니메이션 컨트롤러들
  late AnimationController _loadingAnimationController;
  late Animation<double> _dot1Animation;
  late Animation<double> _dot2Animation;
  late Animation<double> _dot3Animation;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _controller.clear();
      _isLoading = true;
    });
    
    // 로딩 애니메이션 시작
    _loadingAnimationController.repeat();

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
      
      // 로딩 애니메이션 중지
      _loadingAnimationController.stop();
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(text: "죄송합니다. 오류가 발생했습니다: $e", isUser: false));
        _isLoading = false;
      });
      
      // 로딩 애니메이션 중지
      _loadingAnimationController.stop();
      print('챗봇 API 에러: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    
    // 기사 ID 설정
    _articleId = widget.articleId;
    
    // 기사 정보가 있으면 ChatService에 설정
    if (_articleId != null) {
      _loadArticleInfo();
    }
    
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
    
    // 로딩 애니메이션 초기화
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // 각 점의 애니메이션 (시간차를 두어 순차적으로 움직이게)
    _dot1Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));
    
    _dot2Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));
    
    _dot3Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
    ));
  }
  
  // 기사 정보 로드
  Future<void> _loadArticleInfo() async {
    if (_articleId == null) return;
    
    try {
      final apiService = ApiService();
      await apiService.initialize();
      final response = await apiService.get('/api/v1/articles/$_articleId');
      final data = response.data;
      
      // ChatService에 기사 정보 설정
      print('API 응답 데이터: $data');
      print('썸네일 URL: ${data['thumbnail_image_url']}');
      
      // ChatService에 기사 정보 설정
      _chatService.setArticleInfo(
        articleId: _articleId,
        title: data['title'],
        category: data['category_name'],
        thumbnail: data['thumbnail_image_url'],
      );
      
      // UI 강제 업데이트
      if (mounted) {
        setState(() {
          print('기사 정보 설정 완료: ${_chatService.currentArticleTitle}');
          print('썸네일 URL: ${_chatService.currentArticleThumbnail}');
        });
        
        // 잠시 후 한 번 더 업데이트 (이미지 로딩 보장)
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              print('UI 재업데이트 완료');
            });
          }
        });
      }
      
      // 제목 애니메이션 설정
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final title = _chatService.currentArticleTitle ?? '기사 제목을 불러오는 중...';
        if (title.length > 14) {
          setState(() {
            shouldAnimate = true;
          });
          _titleAnimationController.repeat();
        }
      });
    } catch (e) {
      print('기사 정보 로드 에러: $e');
    }
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
                        // 기사 사진
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _chatService.currentArticleThumbnail != null && _chatService.currentArticleThumbnail!.isNotEmpty
                                ? Image.network(
                                    '${_chatService.currentArticleThumbnail!}?t=${DateTime.now().millisecondsSinceEpoch}',
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    headers: const {
                                      'Cache-Control': 'no-cache',
                                      'Pragma': 'no-cache',
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 64,
                                        height: 64,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Color(0xFF0565FF),
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      print('이미지 로드 에러: $error');
                                      print('이미지 URL: ${_chatService.currentArticleThumbnail}');
                                      // 기본 이미지 표시
                                      return Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0565FF).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.article,
                                          size: 32,
                                          color: Color(0xFF0565FF),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0565FF).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.article,
                                      size: 32,
                                      color: Color(0xFF0565FF),
                                    ),
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
                                child: Text(
                                  _chatService.currentArticleCategory ?? '기사',
                                  style: const TextStyle(
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
                                              _chatService.currentArticleTitle ?? '기사 제목을 불러오는 중...',
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
                                            _chatService.currentArticleTitle ?? '기사 제목을 불러오는 중...',
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
                      itemCount: _messages.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        // 로딩 중이고 마지막 인덱스라면 로딩 애니메이션 표시
                        if (_isLoading && index == _messages.length) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              constraints: const BoxConstraints(maxWidth: 260),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(18),
                                  topRight: const Radius.circular(18),
                                  bottomLeft: const Radius.circular(4),
                                  bottomRight: const Radius.circular(18),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: _LoadingAnimation(
                                dot1Animation: _dot1Animation,
                                dot2Animation: _dot2Animation,
                                dot3Animation: _dot3Animation,
                              ),
                            ),
                          );
                        }
                        
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
    _loadingAnimationController.dispose();
    super.dispose();
  }
}
