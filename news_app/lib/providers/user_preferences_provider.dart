import 'package:flutter/foundation.dart';
import '../models/common_models.dart';
import '../models/user_models.dart';
import '../services/user_preferences_service.dart';

class UserPreferencesProvider extends ChangeNotifier {
  final UserPreferencesService _preferencesService = UserPreferencesService();
  
  UserPreferences? _preferences;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserPreferences? get preferences => _preferences;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // 개별 설정 getters - 새로운 API 응답 구조에 맞춰 수정
  String? get preferredVoice => _preferences?.voiceType;
  List<String>? get favoriteCategories => _preferences?.category;
  List<String>? get favoriteKeywords => _preferences?.keyword;
  List<String>? get favoriteMedia => _preferences?.press;
  
  // 기존 모델과의 호환성을 위한 getters (필요시 사용)
  int? get fontSize => null; // API에서 제공하지 않음
  bool? get autoPlay => null; // API에서 제공하지 않음

  /// 사용자 설정 로드
  Future<void> loadUserPreferences() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _preferences = await _preferencesService.getUserPreferences();
    } catch (e) {
      _error = e.toString();
      print('사용자 설정 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 전체 설정 업데이트
  Future<void> updateUserPreferences({
    String? preferredVoice,
    int? fontSize,
    bool? autoPlay,
    List<String>? favoriteCategories,
    List<String>? favoriteKeywords,
    List<String>? favoriteMedia,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _preferences = await _preferencesService.updateUserPreferences(
        preferredVoice: preferredVoice,
        fontSize: fontSize,
        autoPlay: autoPlay,
        favoriteCategories: favoriteCategories,
        favoriteKeywords: favoriteKeywords,
        favoriteMedia: favoriteMedia,
      );
    } catch (e) {
      _error = e.toString();
      print('사용자 설정 업데이트 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 관심 카테고리 업데이트
  Future<void> updateFavoriteCategories(List<String> categories) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _preferences = await _preferencesService.updateFavoriteCategories(categories);
    } catch (e) {
      _error = e.toString();
      print('관심 카테고리 업데이트 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 관심 키워드 업데이트
  Future<void> updateFavoriteKeywords(List<String> keywords) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _preferences = await _preferencesService.updateFavoriteKeywords(keywords);
    } catch (e) {
      _error = e.toString();
      print('관심 키워드 업데이트 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 관심 언론사 업데이트
  Future<void> updateFavoriteMedia(List<String> media) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _preferences = await _preferencesService.updateFavoriteMedia(media);
    } catch (e) {
      _error = e.toString();
      print('관심 언론사 업데이트 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// TTS 음성 설정 업데이트
  Future<void> updatePreferredVoice(String voice) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _preferences = await _preferencesService.updatePreferredVoice(voice);
    } catch (e) {
      _error = e.toString();
      print('TTS 음성 설정 업데이트 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 폰트 크기 업데이트
  Future<void> updateFontSize(int fontSize) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _preferences = await _preferencesService.updateFontSize(fontSize);
    } catch (e) {
      _error = e.toString();
      print('폰트 크기 업데이트 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 자동 재생 설정 업데이트
  Future<void> updateAutoPlay(bool autoPlay) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _preferences = await _preferencesService.updateAutoPlay(autoPlay);
    } catch (e) {
      _error = e.toString();
      print('자동 재생 설정 업데이트 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 에러 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// 로컬 상태 초기화 (로그아웃 시 사용)
  void clearPreferences() {
    _preferences = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
} 