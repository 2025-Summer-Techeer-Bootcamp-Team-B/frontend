

class ChatMessageModel {
  final String conversationId;
  final String response;
  final Map<String, dynamic>? articleContext;
  final String? articleTitle;
  final String? articleCategory;
  final String? articleThumbnail;

  ChatMessageModel({
    required this.conversationId,
    required this.response,
    this.articleContext,
    this.articleTitle,
    this.articleCategory,
    this.articleThumbnail,
  });

  // 3. 응답 처리 - fromJson() 메서드
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final articleContext = json['article_context'] as Map<String, dynamic>?;
    return ChatMessageModel(
      conversationId: json['conversation_id'] as String,
      response: json['response'] as String,
      articleContext: articleContext,
      articleTitle: articleContext?['title'] as String?,
      articleCategory: articleContext?['category'] as String?,
      articleThumbnail: articleContext?['thumbnail_image_url'] as String?,
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