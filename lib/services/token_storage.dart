import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userEmailKey = 'user_email';

  // 액세스 토큰 저장
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  // 리프레시 토큰 저장
  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  // 토큰들 저장
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_accessTokenKey, accessToken),
      prefs.setString(_refreshTokenKey, refreshToken),
    ]);
  }

  // 액세스 토큰 불러오기
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // 리프레시 토큰 불러오기
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // 토큰들 불러오기
  static Future<Map<String, String?>> getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'accessToken': prefs.getString(_accessTokenKey),
      'refreshToken': prefs.getString(_refreshTokenKey),
    };
  }

  // 액세스 토큰 삭제
  static Future<void> removeAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }

  // 리프레시 토큰 삭제
  static Future<void> removeRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshTokenKey);
  }

  // 사용자 이메일 저장
  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  // 사용자 이메일 불러오기
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // 사용자 이메일 삭제
  static Future<void> removeUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userEmailKey);
  }

  // 모든 토큰 삭제
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_accessTokenKey),
      prefs.remove(_refreshTokenKey),
      prefs.remove(_userEmailKey),
    ]);
  }

  // 토큰 존재 여부 확인
  static Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<bool> hasRefreshToken() async {
    final token = await getRefreshToken();
    return token != null && token.isNotEmpty;
  }
} 