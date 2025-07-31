import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserInfoProvider extends ChangeNotifier {
  String? _userEmail;
  
  String? get userEmail => _userEmail;
  
  // 사용자 정보 설정
  void setUserInfo(String email) {
    _userEmail = email;
    _saveToStorage();
    notifyListeners();
  }
  
  // 사용자 정보 로드
  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');
      if (userEmail != null) {
        _userEmail = userEmail;
        notifyListeners();
      }
    } catch (e) {
      print('사용자 정보 로드 실패: $e');
    }
  }
  
  // 사용자 정보 저장
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_userEmail != null) {
        await prefs.setString('user_email', _userEmail!);
      }
    } catch (e) {
      print('사용자 정보 저장 실패: $e');
    }
  }
  
  // 사용자 정보 삭제 (로그아웃 시)
  Future<void> clearUserInfo() async {
    _userEmail = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_email');
    } catch (e) {
      print('사용자 정보 삭제 실패: $e');
    }
    notifyListeners();
  }
} 