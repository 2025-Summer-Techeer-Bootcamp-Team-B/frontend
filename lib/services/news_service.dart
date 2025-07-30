import '../models/article_models.dart';
import '../models/common_models.dart';
import 'api_service.dart';

class NewsService {
  static final NewsService _instance = NewsService._internal();
  factory NewsService() => _instance;
  NewsService._internal();

  final ApiService _apiService = ApiService();

  /// 실시간 속보 조회
  Future<List<ArticleModel>> getBreakingNews() async {
    try {
      final response = await _apiService.get(ApiEndpoints.breakingNews);
      return (response.data as List?)
              ?.map((article) => ArticleModel.fromJson(article))
              .toList() ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 관심 카테고리 기사 조회
  Future<List<ArticleModel>> getPreferredCategoryArticles(String categoryName) async {
    try {
      // 실제 API 호출 (preferred-category 사용)
      final response = await _apiService.get('/api/v1/articles/preferred-category', queryParameters: {'category_name': categoryName});
      final List<dynamic> articles = response.data;
      return articles.map((article) => ArticleModel.fromJson(article)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// 오늘의 뉴스 조회
  Future<List<ArticleModel>> getTodayNews() async {
    try {
      final response = await _apiService.get(ApiEndpoints.todayNews);
      return (response.data as List?)
              ?.map((article) => ArticleModel.fromJson(article))
              .toList() ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  /// 카테고리별 뉴스 조회
  Future<NewsSearchResponse> getCategoryNews({
    required String category,
    int page = 1,
    int size = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.categoryNews,
        queryParameters: {
          'category': category,
          'page': page,
          'size': size,
        },
      );

      return NewsSearchResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 키워드별 뉴스 조회
  Future<NewsSearchResponse> getKeywordNews({
    required String keyword,
    int page = 1,
    int size = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.keywordNews,
        queryParameters: {
          'keyword': keyword,
          'page': page,
          'size': size,
        },
      );

      return NewsSearchResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 뉴스 상세 조회
  Future<ArticleModel> getNewsDetail(int articleId) async {
    try {
      final response =
          await _apiService.get('${ApiEndpoints.newsDetail}/$articleId');
      return ArticleModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 뉴스 검색
  Future<NewsSearchResponse> searchNews(NewsSearchRequest request) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.searchNews,
        queryParameters: request.toJson(),
      );

      return NewsSearchResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 카테고리 목록 조회
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiService.get(ApiEndpoints.categories);
      return (response.data['categories'] as List?)
              ?.map((category) => CategoryModel.fromJson(category))
              .toList() ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  /// 키워드 목록 조회
  Future<List<KeywordModel>> getKeywords() async {
    try {
      final response = await _apiService.get(ApiEndpoints.keywords);
      return (response.data['keywords'] as List?)
              ?.map((keyword) => KeywordModel.fromJson(keyword))
              .toList() ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  /// 즐겨찾기 추가
  Future<void> addToFavorites(int articleId) async {
    try {
      await _apiService.post(
        ApiEndpoints.addToFavorites,
        data: {'articleId': articleId},
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 즐겨찾기 제거
  Future<void> removeFromFavorites(int articleId) async {
    try {
      await _apiService
          .delete('${ApiEndpoints.removeFromFavorites}/$articleId');
    } catch (e) {
      rethrow;
    }
  }

  /// 즐겨찾기 목록 조회
  Future<NewsSearchResponse> getFavorites({
    int page = 1,
    int size = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.favorites,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      return NewsSearchResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 재생 기록 추가
  Future<void> addToHistory(int articleId) async {
    try {
      await _apiService.post(
        ApiEndpoints.addToHistory,
        data: {'articleId': articleId},
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 재생 기록 조회
  Future<NewsSearchResponse> getHistory({
    int page = 1,
    int size = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.history,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      return NewsSearchResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 추천 뉴스 조회 (OpenSearch 기반)
  Future<List<ArticleModel>> getRecommendedArticles() async {
    try {
      final response = await _apiService.get('/api/v1/articles/recommend');
      return (response.data as List?)
              ?.map((article) => ArticleModel.fromJson(article))
              .toList() ??
          [];
    } catch (e) {
      rethrow;
    }
  }
}
