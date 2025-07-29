import 'common_models.dart';

// 뉴스/기사 관련 모델들
class ArticleModel {
  final String id;
  final String title;
  final String? thumbnailImageUrl;
  final String? categoryName;
  final String? author;
  final DateTime? publishedAt;
  final String? femaleAudioUrl;
  final String? maleAudioUrl;

  ArticleModel({
    required this.id,
    required this.title,
    this.thumbnailImageUrl,
    this.categoryName,
    this.author,
    this.publishedAt,
    this.femaleAudioUrl,
    this.maleAudioUrl,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      thumbnailImageUrl: json['thumbnail_image_url'],
      categoryName: json['category_name'],
      author: json['author'],
      publishedAt: json['published_at'] != null ? DateTime.tryParse(json['published_at']) : null,
      femaleAudioUrl: json['female_audio_url'],
      maleAudioUrl: json['male_audio_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail_image_url': thumbnailImageUrl,
      'category_name': categoryName,
      'author': author,
      'published_at': publishedAt?.toIso8601String(),
      'female_audio_url': femaleAudioUrl,
      'male_audio_url': maleAudioUrl,
    };
  }
}

class CategoryModel {
  final String id;
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
      id: json['id']?.toString() ?? '',
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
  final String id;
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
      id: json['id']?.toString() ?? '',
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
