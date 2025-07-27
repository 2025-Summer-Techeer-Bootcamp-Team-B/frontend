import 'package:flutter/foundation.dart';
import '../models/common_models.dart';
import '../services/user_keywords_service.dart';

class UserKeywordsProvider extends ChangeNotifier {
  final UserKeywordsService _keywordsService = UserKeywordsService();
  
  UserKeywords? _userKeywords;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserKeywords? get userKeywords => _userKeywords;
  List<String> get keywords => _userKeywords?.keywords ?? [];
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 사용자 관심 키워드 로드
  Future<void> loadUserKeywords() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _userKeywords = await _keywordsService.getUserKeywords();
    } catch (e) {
      _error = e.toString();
      print('사용자 키워드 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 키워드 목록만 가져오기
  Future<List<String>> loadKeywordsList() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final keywordsList = await _keywordsService.getKeywordsList();
      return keywordsList;
    } catch (e) {
      _error = e.toString();
      print('키워드 목록 로드 실패: $e');
      return [];
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
  void clearKeywords() {
    _userKeywords = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
} 