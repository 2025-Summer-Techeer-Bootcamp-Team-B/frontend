import '../models/user_models.dart';
import '../models/common_models.dart';
import 'api_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final ApiService _apiService = ApiService();

  /// 사용자 프로필 조회
  Future<UserModel> getUserProfile() async {
    try {
      final response = await _apiService.get(ApiEndpoints.userProfile);
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 프로필 업데이트
  Future<UserModel> updateUserProfile({
    String? nickname,
    String? profileImage,
    String? phoneNumber,
    UserPreferences? preferences,
  }) async {
    try {
      final request = UpdateUserRequest(
        nickname: nickname,
        profileImage: profileImage,
        phoneNumber: phoneNumber,
        preferences: preferences,
      );

      final response = await _apiService.patch(
        ApiEndpoints.updateProfile,
        data: request.toJson(),
      );

      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 카테고리 조회
  Future<List<String>> getUserCategories() async {
    try {
      final response = await _apiService.get(ApiEndpoints.userCategories);
      return List<String>.from(response.data['categories'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 카테고리 업데이트
  Future<void> updateUserCategories(List<String> categories) async {
    try {
      await _apiService.put(
        ApiEndpoints.userCategories,
        data: {'categories': categories},
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 키워드 조회
  Future<List<String>> getUserKeywords() async {
    try {
      final response = await _apiService.get(ApiEndpoints.userKeywords);
      return List<String>.from(response.data['keywords'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 키워드 업데이트
  Future<void> updateUserKeywords(List<String> keywords) async {
    try {
      await _apiService.put(
        ApiEndpoints.userKeywords,
        data: {'keywords': keywords},
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 설정 조회
  Future<UserPreferences> getUserPreferences() async {
    try {
      final response =
          await _apiService.get('${ApiEndpoints.userProfile}/preferences');
      return UserPreferences.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 설정 업데이트
  Future<UserPreferences> updateUserPreferences(
      UserPreferences preferences) async {
    try {
      final response = await _apiService.patch(
        '${ApiEndpoints.userProfile}/preferences',
        data: preferences.toJson(),
      );

      return UserPreferences.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 계정 삭제
  Future<void> deleteAccount() async {
    try {
      await _apiService.delete(ApiEndpoints.userProfile);
    } catch (e) {
      rethrow;
    }
  }
}
