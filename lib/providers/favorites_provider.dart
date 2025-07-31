import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_models.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteArticleIds = {};
  final List<ArticleModel> _favoriteArticles = [];

  // 즐겨찾기된 기사 ID 목록
  Set<String> get favoriteArticleIds => _favoriteArticleIds;

  // 즐겨찾기된 기사 목록
  List<ArticleModel> get favoriteArticles => _favoriteArticles;

  // 특정 기사가 즐겨찾기되어 있는지 확인
  bool isFavorite(String articleId) {
    return _favoriteArticleIds.contains(articleId);
  }

    // 즐겨찾기 추가/제거 토글
  void toggleFavorite(ArticleModel article) {
    final articleId = article.id;

    if (_favoriteArticleIds.contains(articleId)) {
      // 즐겨찾기에서 제거
      _favoriteArticleIds.remove(articleId);
      _favoriteArticles.removeWhere((a) => a.id == articleId);
    } else {
      // 즐겨찾기에 추가
      _favoriteArticleIds.add(articleId);
      _favoriteArticles.add(article);
    }

    notifyListeners();
    _saveToStorage();
  }

  // 즐겨찾기 추가
  void addToFavorites(ArticleModel article) {
    final articleId = article.id;
    if (!_favoriteArticleIds.contains(articleId)) {
      _favoriteArticleIds.add(articleId);
      _favoriteArticles.add(article);
      notifyListeners();
      _saveToStorage();
    }
  }

  // 즐겨찾기 제거
  void removeFromFavorites(String articleId) {
    if (_favoriteArticleIds.contains(articleId)) {
      _favoriteArticleIds.remove(articleId);
      _favoriteArticles.removeWhere((a) => a.id == articleId);
      notifyListeners();
      _saveToStorage();
    }
  }

  // 즐겨찾기 목록 초기화
  void clearFavorites() {
    _favoriteArticleIds.clear();
    _favoriteArticles.clear();
    notifyListeners();
    _saveToStorage();
  }
  
  // SharedPreferences에 저장
  void _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = _favoriteArticles.map((article) => article.toJson()).toList();
      await prefs.setString('favorites', jsonEncode(favoritesJson));
    } catch (e) {
      print('즐겨찾기 저장 실패: $e');
    }
  }
  
  // SharedPreferences에서 로드
  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesString = prefs.getString('favorites');
      
      if (favoritesString != null) {
        final favoritesList = jsonDecode(favoritesString) as List;
        _favoriteArticles.clear();
        _favoriteArticles.addAll(
          favoritesList.map((json) => ArticleModel.fromJson(json)).toList()
        );
        
        // ID 목록도 업데이트
        _favoriteArticleIds.clear();
        _favoriteArticleIds.addAll(_favoriteArticles.map((article) => article.id));
        
        notifyListeners();
      }
    } catch (e) {
      print('즐겨찾기 로드 실패: $e');
    }
  }
} 