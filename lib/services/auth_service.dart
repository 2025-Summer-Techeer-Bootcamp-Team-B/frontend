import 'package:flutter/material.dart';
import '../models/auth_models.dart';
import '../models/common_models.dart';
import 'api_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_info_provider.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();

  /// 로그인
  Future<AuthResponse> login(String email, String password, BuildContext context) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiService.post(
        '/api/v1/auth/login',
        data: request.toJson(),
      );
      final authResponse = AuthResponse.fromJson(response.data);
      // 액세스 토큰과 리프레시 토큰 모두 저장
      await _apiService.setTokens(authResponse.accessToken ?? '', authResponse.refreshToken ?? '');
      
      // 사용자 정보 저장
      final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
      userInfoProvider.setUserInfo(email);
      
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// 회원가입
  Future<AuthResponse> register({
    required String email,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        password: password,
      );
      final response = await _apiService.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );
      final authResponse = AuthResponse.fromJson(response.data);
      // 액세스 토큰과 리프레시 토큰 모두 저장
      await _apiService.setTokens(authResponse.accessToken ?? '', authResponse.refreshToken ?? '');
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// 토큰 갱신
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final request = RefreshTokenRequest(refreshToken: refreshToken);
      final response = await _apiService.post(
        ApiEndpoints.refreshToken,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // 토큰 갱신 성공 시 새 토큰들 저장
      await _apiService.setTokens(authResponse.accessToken ?? '', authResponse.refreshToken ?? '');

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      await _apiService.post(ApiEndpoints.logout);

      // 로그아웃 시 모든 토큰 제거
      await _apiService.clearTokens();
    } catch (e) {
      // 로그아웃 실패해도 토큰은 제거
      await _apiService.clearTokens();
      rethrow;
    }
  }

  /// 이메일 중복 확인 (Swagger 명세)
  Future<bool> checkEmailDuplicate(String email) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.checkEmailExists,
        queryParameters: {'email': email},
      );
      final result = EmailExistsResponse.fromJson(response.data);
      return result.exists;
    } catch (e) {
      rethrow;
    }
  }

  /// 비밀번호 변경
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      await _apiService.post(
        ApiEndpoints.changePassword,
        data: request.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 현재 토큰 상태 확인
  bool get isLoggedIn => _apiService.hasAccessToken;

  /// 토큰 설정 (외부에서 사용)
  Future<void> setToken(String accessToken, String refreshToken) async {
    await _apiService.setTokens(accessToken, refreshToken);
  }

  /// 토큰 제거 (외부에서 사용)
  Future<void> clearToken() async {
    await _apiService.clearTokens();
  }
}
