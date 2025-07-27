import 'package:flutter/foundation.dart';
import '../models/common_models.dart';
import '../services/user_voice_type_service.dart';

class UserVoiceTypeProvider extends ChangeNotifier {
  final UserVoiceTypeService _voiceTypeService = UserVoiceTypeService();
  
  UserVoiceType? _voiceType;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  // Getters
  UserVoiceType? get voiceType => _voiceType;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;
  
  // 편의 getters
  String get currentVoiceType => _voiceType?.voiceType ?? 'male';
  bool get isMale => _voiceType?.isMale ?? true;
  bool get isFemale => _voiceType?.isFemale ?? false;
  String get displayName => _voiceType?.displayName ?? '남성';

  /// 사용자 TTS 음성 타입 로드
  Future<void> loadUserVoiceType() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _voiceType = await _voiceTypeService.getUserVoiceType();
      _isInitialized = true;
    } catch (e) {
      _error = e.toString();
      print('사용자 음성 타입 로드 실패: $e');
      // 에러 시 기본값 설정
      _voiceType = _voiceTypeService.getDefaultVoiceType();
      _isInitialized = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 음성 타입 설정 (로컬 상태 업데이트)
  void setVoiceType(String voiceType) {
    _voiceType = UserVoiceType(voiceType: voiceType);
    _isInitialized = true;
    notifyListeners();
  }

  /// 음성 타입 업데이트 (API 호출)
  Future<void> updateVoiceType(String voiceType) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _voiceType = await _voiceTypeService.updateVoiceType(voiceType);
      
      // 성공 시 로컬 상태도 업데이트
      _isInitialized = true;
    } catch (e) {
      _error = e.toString();
      print('음성 타입 업데이트 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 기본값으로 초기화
  void initializeWithDefault() {
    _voiceType = _voiceTypeService.getDefaultVoiceType();
    _isInitialized = true;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// 에러 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// 로컬 상태 초기화 (로그아웃 시 사용)
  void clearVoiceType() {
    _voiceType = null;
    _error = null;
    _isLoading = false;
    _isInitialized = false;
    notifyListeners();
  }
} 