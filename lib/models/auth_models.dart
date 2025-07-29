import 'user_models.dart';

// 인증 관련 모델들
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String email;
  final String password;

  RegisterRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class AuthResponse {
  final String? message;
  final String? email;
  final String? accessToken;
  final String? refreshToken;

  AuthResponse({
    this.message,
    this.email,
    this.accessToken,
    this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'],
      email: json['email'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken, // 백엔드 API 스펙에 맞게 수정
    };
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}

class EmailExistsResponse {
  final bool exists;
  final String email;

  EmailExistsResponse({
    required this.exists,
    required this.email,
  });

  factory EmailExistsResponse.fromJson(Map<String, dynamic> json) {
    return EmailExistsResponse(
      exists: json['exists'] ?? false,
      email: json['email'] ?? '',
    );
  }
}
