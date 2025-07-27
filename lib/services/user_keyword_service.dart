import '../models/common_models.dart';
import 'api_service.dart';

class UserKeywordService {
  static final UserKeywordService _instance = UserKeywordService._internal();
  factory UserKeywordService() => _instance;
  UserKeywordService._internal();

  final ApiService _apiService = ApiService();

  /// 사용자 관심 키워드 조회 (GET)
  Future<UserKeyword> getUserKeywords() async {
    try {
      final response = await _apiService.getUserKeywords();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 관심 키워드 업데이트 (PUT/POST - 백엔드 API에 따라)
  Future<UserKeyword> updateUserKeywords(List<String> keywords) async {
    try {
      // TODO: 백엔드에서 키워드 업데이트 API가 제공되면 구현
      // 현재는 조회만 가능하도록 구현
      throw Exception('키워드 업데이트 API가 아직 구현되지 않았습니다.');
    } catch (e) {
      rethrow;
    }
  }

  /// 키워드 추가
  Future<UserKeyword> addKeyword(String keyword) async {
    try {
      // TODO: 백엔드에서 키워드 추가 API가 제공되면 구현
      throw Exception('키워드 추가 API가 아직 구현되지 않았습니다.');
    } catch (e) {
      rethrow;
    }
  }

  /// 키워드 삭제
  Future<UserKeyword> removeKeyword(String keyword) async {
    try {
      // TODO: 백엔드에서 키워드 삭제 API가 제공되면 구현
      throw Exception('키워드 삭제 API가 아직 구현되지 않았습니다.');
    } catch (e) {
      rethrow;
    }
  }
} 