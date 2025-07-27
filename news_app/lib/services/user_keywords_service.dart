import '../models/common_models.dart';
import 'api_service.dart';

class UserKeywordsService {
  static final UserKeywordsService _instance = UserKeywordsService._internal();
  factory UserKeywordsService() => _instance;
  UserKeywordsService._internal();

  final ApiService _apiService = ApiService();

  /// 사용자 관심 키워드 조회 (GET)
  Future<UserKeywords> getUserKeywords() async {
    try {
      final response = await _apiService.getUserKeywords();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 키워드 목록 가져오기 (편의 메서드)
  Future<List<String>> getKeywordsList() async {
    try {
      final userKeywords = await getUserKeywords();
      return userKeywords.keywords;
    } catch (e) {
      rethrow;
    }
  }
} 