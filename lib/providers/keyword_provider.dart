import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_services.dart';

class KeywordProvider extends ChangeNotifier {
  List<String> _selectedKeywords = [];
  List<NewsModel> _keywordNews = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<String> get selectedKeywords => _selectedKeywords;
  List<NewsModel> get keywordNews => _keywordNews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 키워드 추가
  void addKeyword(String keyword) {
    if (!_selectedKeywords.contains(keyword)) {
      _selectedKeywords.add(keyword);
      notifyListeners();
    }
  }

  // 키워드 제거
  void removeKeyword(String keyword) {
    _selectedKeywords.remove(keyword);
    notifyListeners();
  }

  // 키워드 목록 설정
  void setKeywords(List<String> keywords) {
    _selectedKeywords = keywords;
    notifyListeners();
  }

  // 키워드로 뉴스 검색
  Future<void> fetchKeywordNews() async {
    if (_selectedKeywords.isEmpty) {
      _keywordNews = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newsService = NewsService();
      _keywordNews = await newsService.fetchNewsList();
      // 키워드 필터링 로직을 여기에 추가할 수 있습니다
      notifyListeners();
    } catch (e) {
      _error = '뉴스를 불러오는데 실패했습니다: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 에러 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // 로딩 상태 초기화
  void clearLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
