import '../models/common_models.dart';
import '../models/user_models.dart';
import 'api_service.dart';

class UserPreferencesService {
  static final UserPreferencesService _instance = UserPreferencesService._internal();
  factory UserPreferencesService() => _instance;
  UserPreferencesService._internal();

  final ApiService _apiService = ApiService();

  /// 사용자 설정 조회 (GET) - API 문서에 맞춰 수정
  Future<UserPreferences> getUserPreferences() async {
    try {
      // API 문서의 /api/v1/user/press 엔드포인트 사용
      final response = await _apiService.getUserPreferences();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 설정 업데이트 (PUT)
  Future<UserPreferences> updateUserPreferences({
    String? preferredVoice, // 'male' 또는 'female'
    int? fontSize,
    bool? autoPlay,
    List<String>? favoriteCategories,
    List<String>? favoriteKeywords,
    List<String>? favoriteMedia, // 관심 언론사 추가
  }) async {
    try {
      final preferences = UserPreferences(
        voiceType: preferredVoice,
        fontSize: fontSize,
        autoPlay: autoPlay,
        category: favoriteCategories,
        keyword: favoriteKeywords,
        press: favoriteMedia,
      );

      final request = UpdateUserRequest(preferences: preferences);
      
      final response = await _apiService.put(
        ApiEndpoints.userPreferences,
        data: request.toJson(),
      );
      
      return UserPreferences.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 관심 카테고리만 업데이트
  Future<UserPreferences> updateFavoriteCategories(List<String> categories) async {
    try {
      final currentPreferences = await getUserPreferences();
      
      return await updateUserPreferences(
        preferredVoice: currentPreferences.preferredVoice,
        fontSize: currentPreferences.fontSize,
        autoPlay: currentPreferences.autoPlay,
        favoriteCategories: categories,
        favoriteKeywords: currentPreferences.favoriteKeywords,
        favoriteMedia: currentPreferences.favoriteMedia,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 관심 키워드만 업데이트
  Future<UserPreferences> updateFavoriteKeywords(List<String> keywords) async {
    try {
      final currentPreferences = await getUserPreferences();
      
      return await updateUserPreferences(
        preferredVoice: currentPreferences.preferredVoice,
        fontSize: currentPreferences.fontSize,
        autoPlay: currentPreferences.autoPlay,
        favoriteCategories: currentPreferences.favoriteCategories,
        favoriteKeywords: keywords,
        favoriteMedia: currentPreferences.favoriteMedia,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 관심 언론사만 업데이트
  Future<UserPreferences> updateFavoriteMedia(List<String> media) async {
    try {
      final currentPreferences = await getUserPreferences();
      
      return await updateUserPreferences(
        preferredVoice: currentPreferences.preferredVoice,
        fontSize: currentPreferences.fontSize,
        autoPlay: currentPreferences.autoPlay,
        favoriteCategories: currentPreferences.favoriteCategories,
        favoriteKeywords: currentPreferences.favoriteKeywords,
        favoriteMedia: media,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// TTS 음성 설정만 업데이트
  Future<UserPreferences> updatePreferredVoice(String voice) async {
    try {
      final currentPreferences = await getUserPreferences();
      
      return await updateUserPreferences(
        preferredVoice: voice,
        fontSize: currentPreferences.fontSize,
        autoPlay: currentPreferences.autoPlay,
        favoriteCategories: currentPreferences.favoriteCategories,
        favoriteKeywords: currentPreferences.favoriteKeywords,
        favoriteMedia: currentPreferences.favoriteMedia,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 폰트 크기만 업데이트
  Future<UserPreferences> updateFontSize(int fontSize) async {
    try {
      final currentPreferences = await getUserPreferences();
      
      return await updateUserPreferences(
        preferredVoice: currentPreferences.preferredVoice,
        fontSize: currentPreferences.fontSize,
        autoPlay: currentPreferences.autoPlay,
        favoriteCategories: currentPreferences.favoriteCategories,
        favoriteKeywords: currentPreferences.favoriteKeywords,
        favoriteMedia: currentPreferences.favoriteMedia,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 자동 재생 설정만 업데이트
  Future<UserPreferences> updateAutoPlay(bool autoPlay) async {
    try {
      final currentPreferences = await getUserPreferences();
      
      return await updateUserPreferences(
        preferredVoice: currentPreferences.preferredVoice,
        fontSize: currentPreferences.fontSize,
        autoPlay: autoPlay,
        favoriteCategories: currentPreferences.favoriteCategories,
        favoriteKeywords: currentPreferences.favoriteKeywords,
        favoriteMedia: currentPreferences.favoriteMedia,
      );
    } catch (e) {
      rethrow;
    }
  }
} 