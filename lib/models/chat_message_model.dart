

class ChatMessageModel {
  final String conversationId;
  final String response;
  final Map<String, dynamic>? articleContext;

  ChatMessageModel({
    required this.conversationId,
    required this.response,
    this.articleContext,
  });

  // 3. 응답 처리 - fromJson() 메서드
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      conversationId: json['conversation_id'] as String,
      response: json['response'] as String,
      articleContext: json['article_context'] as Map<String, dynamic>?,
    );
  }
}

class ChatRequestModel {
  final String message;
  final String articleId;
  final String conversationId;

  ChatRequestModel({
    required this.message,
    required this.articleId,
    required this.conversationId,
  });

  // 2. 요청 바디 - toJson() 메서드
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'article_id': articleId,
      'conversation_id': conversationId,
    };
  }
} 