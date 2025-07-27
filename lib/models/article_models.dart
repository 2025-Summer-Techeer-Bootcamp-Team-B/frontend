import 'common_models.dart';

// 뉴스/기사 관련 모델들
class ArticleModel {
  final int id;
  final String title;
  final String content;
  final String summary;
  final String source;
  final String url;
  final String? imageUrl;
  final DateTime publishedAt;
  final DateTime createdAt;
  final List<String> categories;
  final List<String> keywords;
  final bool isBreaking;
  final bool isFavorite;
  final int viewCount;
  final int playCount;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.source,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    required this.createdAt,
    required this.categories,
    required this.keywords,
    required this.isBreaking,
    required this.isFavorite,
    required this.viewCount,
    required this.playCount,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      summary: json['summary'] ?? '',
      source: json['source'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['imageUrl'],
      publishedAt: DateTime.parse(
          json['publishedAt'] ?? DateTime.now().toIso8601String()),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      categories: List<String>.from(json['categories'] ?? []),
      keywords: List<String>.from(json['keywords'] ?? []),
      isBreaking: json['isBreaking'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      viewCount: json['viewCount'] ?? 0,
      playCount: json['playCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'source': source,
      'url': url,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'categories': categories,
      'keywords': keywords,
      'isBreaking': isBreaking,
      'isFavorite': isFavorite,
      'viewCount': viewCount,
      'playCount': playCount,
    };
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String? description;
  final String? icon;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      icon: json['icon'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'isActive': isActive,
    };
  }
}

class KeywordModel {
  final int id;
  final String keyword;
  final String? description;
  final bool isActive;

  KeywordModel({
    required this.id,
    required this.keyword,
    this.description,
    required this.isActive,
  });

  factory KeywordModel.fromJson(Map<String, dynamic> json) {
    return KeywordModel(
      id: json['id'] ?? 0,
      keyword: json['keyword'] ?? '',
      description: json['description'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keyword': keyword,
      'description': description,
      'isActive': isActive,
    };
  }
}

class NewsSearchRequest {
  final String? query;
  final List<String>? categories;
  final List<String>? keywords;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isBreaking;
  final int page;
  final int size;

  NewsSearchRequest({
    this.query,
    this.categories,
    this.keywords,
    this.startDate,
    this.endDate,
    this.isBreaking,
    this.page = 1,
    this.size = 20,
  });

  Map<String, dynamic> toJson() {
    return {
      if (query != null) 'query': query,
      if (categories != null) 'categories': categories,
      if (keywords != null) 'keywords': keywords,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      if (isBreaking != null) 'isBreaking': isBreaking,
      'page': page,
      'size': size,
    };
  }
}

class NewsSearchResponse {
  final List<ArticleModel> articles;
  final PaginationInfo pagination;

  NewsSearchResponse({
    required this.articles,
    required this.pagination,
  });

  factory NewsSearchResponse.fromJson(Map<String, dynamic> json) {
    return NewsSearchResponse(
      articles: (json['articles'] as List?)
              ?.map((article) => ArticleModel.fromJson(article))
              .toList() ??
          [],
      pagination: PaginationInfo.fromJson(json['pagination'] ?? {}),
    );
  }
}
