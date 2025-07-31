import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_models.dart';

class HistoryProvider extends ChangeNotifier {
  final List<ArticleModel> _playHistory = [];
  
  // 재생 기록 목록
  List<ArticleModel> get playHistory => _playHistory;
  
  // 재생 기록 추가
  void addToHistory(ArticleModel article) {
    // 이미 있는 기사면 제거 (최신이 위로 오도록)
    _playHistory.removeWhere((item) => item.id == article.id);
    // 맨 앞에 추가
    _playHistory.insert(0, article);
    
    // 최대 50개까지만 유지
    if (_playHistory.length > 50) {
      _playHistory.removeRange(50, _playHistory.length);
    }
    
    notifyListeners();
    _saveToStorage();
  }
  
  // 재생 기록에서 제거
  void removeFromHistory(String articleId) {
    _playHistory.removeWhere((article) => article.id == articleId);
    notifyListeners();
    _saveToStorage();
  }
  
  // 재생 기록 초기화
  void clearHistory() {
    _playHistory.clear();
    notifyListeners();
    _saveToStorage();
  }
  
  // 특정 기사가 재생 기록에 있는지 확인
  bool isInHistory(String articleId) {
    return _playHistory.any((article) => article.id == articleId);
  }
  
  // SharedPreferences에 저장
  void _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = _playHistory.map((article) => article.toJson()).toList();
      await prefs.setString('play_history', jsonEncode(historyJson));
    } catch (e) {
      print('재생 기록 저장 실패: $e');
    }
  }
  
  // SharedPreferences에서 로드
  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyString = prefs.getString('play_history');
      
      if (historyString != null) {
        final historyList = jsonDecode(historyString) as List;
        _playHistory.clear();
        _playHistory.addAll(
          historyList.map((json) => ArticleModel.fromJson(json)).toList()
        );
        notifyListeners();
      }
    } catch (e) {
      print('재생 기록 로드 실패: $e');
    }
  }
} 