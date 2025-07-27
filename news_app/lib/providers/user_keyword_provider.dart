import 'package:flutter/foundation.dart';
import '../models/common_models.dart';
import '../services/user_keyword_service.dart';

class UserKeywordProvider extends ChangeNotifier {
  final UserKeywordService _keywordService = UserKeywordService();
  
  UserKeyword? _keywords;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserKeyword? get keywords => _keywords;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // 편의 getters
  List<String> get keywordList => _keywords?.keywords ?? [];

  /// 사용자 관심 키워드 로드
  Future<void> loadUserKeywords() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _keywords = await _keywordService.getUserKeywords();
    } catch (e) {
      _error = e.toString();
      print('사용자 키워드 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 키워드 업데이트
  Future<void> updateKeywords(List<String> keywords) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _keywords = await _keywordService.updateUserKeywords(keywords);
    } catch (e) {
      _error = e.toString();
      print('키워드 업데이트 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 키워드 추가
  Future<void> addKeyword(String keyword) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _keywords = await _keywordService.addKeyword(keyword);
    } catch (e) {
      _error = e.toString();
      print('키워드 추가 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 키워드 삭제
  Future<void> removeKeyword(String keyword) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _keywords = await _keywordService.removeKeyword(keyword);
    } catch (e) {
      _error = e.toString();
      print('키워드 삭제 실패: $e');
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
    _keywords = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
} 