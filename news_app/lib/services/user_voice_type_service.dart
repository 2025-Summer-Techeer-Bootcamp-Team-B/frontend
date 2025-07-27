import '../models/common_models.dart';
import 'api_service.dart';

class UserVoiceTypeService {
  static final UserVoiceTypeService _instance = UserVoiceTypeService._internal();
  factory UserVoiceTypeService() => _instance;
  UserVoiceTypeService._internal();

  final ApiService _apiService = ApiService();

  /// 사용자 TTS 음성 타입 조회 (GET)
  Future<UserVoiceType> getUserVoiceType() async {
    try {
      final response = await _apiService.getUserVoiceType();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// TTS 음성 타입 업데이트 (PUT)
  Future<UserVoiceType> updateVoiceType(String voiceType) async {
    try {
      final response = await _apiService.updateUserVoiceType(voiceType);
      return UserVoiceType(voiceType: response.voiceType ?? voiceType);
    } catch (e) {
      rethrow;
    }
  }

  /// 기본 음성 타입 반환 (앱 시작 시 사용)
  UserVoiceType getDefaultVoiceType() {
    return UserVoiceType(voiceType: 'male'); // 기본값은 남성
  }
} 