import 'package:dio/dio.dart';
import '../models/common_models.dart';
import 'api_service.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final ApiService _apiService = ApiService();

  // 현재 대화 ID
  String? _currentConversationId;
  
  // 기사 정보
  String? _currentArticleId;
  String? _currentArticleTitle;
  String? _currentArticleCategory;
  String? _currentArticleThumbnail;

  // 현재 대화 ID getter
  String? get currentConversationId => _currentConversationId;
  
  // 기사 정보 getters
  String? get currentArticleId => _currentArticleId;
  String? get currentArticleTitle => _currentArticleTitle;
  String? get currentArticleCategory => _currentArticleCategory;
  String? get currentArticleThumbnail => _currentArticleThumbnail;

  // 새로운 대화 시작
  Future<ChatResponse> startNewConversation(String message,
      {String? articleId}) async {
    try {
      final response = await _apiService.startChatConversation(message,
          articleId: articleId);
      _currentConversationId = response.conversationId;
      
      // 기사 정보 저장
      if (response.articleContext != null) {
        _currentArticleId = articleId;
        _currentArticleTitle = response.articleContext!['title'] as String?;
        _currentArticleCategory = response.articleContext!['category'] as String?;
        _currentArticleThumbnail = response.articleContext!['thumbnail_image_url'] as String?;
      }
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // 기존 대화에 메시지 전송
  Future<ChatResponse> sendMessage(String message, {String? articleId}) async {
    if (_currentConversationId == null) {
      throw Exception('대화가 시작되지 않았습니다. 먼저 새로운 대화를 시작해주세요.');
    }

    try {
      final response = await _apiService.sendChatMessage(
          message, _currentConversationId!,
          articleId: articleId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // 대화 정보 조회
  Future<ConversationInfo?> getConversationInfo() async {
    if (_currentConversationId == null) {
      return null;
    }

    try {
      return await _apiService.getConversationInfo(_currentConversationId!);
    } catch (e) {
      rethrow;
    }
  }

  // 대화 종료 (현재 대화 ID 초기화)
  void endConversation() {
    _currentConversationId = null;
    _currentArticleId = null;
    _currentArticleTitle = null;
    _currentArticleCategory = null;
    _currentArticleThumbnail = null;
  }

  // 대화 ID 설정 (외부에서 설정할 때 사용)
  void setConversationId(String conversationId) {
    _currentConversationId = conversationId;
  }
  
  // 기사 정보 설정 (외부에서 설정할 때 사용)
  void setArticleInfo({
    String? articleId,
    String? title,
    String? category,
    String? thumbnail,
  }) {
    print('ChatService - 기사 정보 설정 시작');
    print('  articleId: $articleId');
    print('  title: $title');
    print('  category: $category');
    print('  thumbnail: $thumbnail');
    
    _currentArticleId = articleId;
    _currentArticleTitle = title;
    _currentArticleCategory = category;
    _currentArticleThumbnail = thumbnail;
    
    print('ChatService - 기사 정보 설정 완료');
    print('  현재 저장된 title: $_currentArticleTitle');
    print('  현재 저장된 thumbnail: $_currentArticleThumbnail');
  }

  // 대화 상태 확인
  bool get isConversationActive => _currentConversationId != null;
}
