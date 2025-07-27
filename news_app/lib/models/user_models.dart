// 사용자 관련 모델들
class UserModel {
  final int id;
  final String email;
  final String nickname;
  final String? profileImage;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> roles;
  final UserPreferences? preferences;

  UserModel({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImage,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
    this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      nickname: json['nickname'] ?? '',
      profileImage: json['profileImage'],
      phoneNumber: json['phoneNumber'],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      roles: List<String>.from(json['roles'] ?? []),
      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(json['preferences'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'roles': roles,
      'preferences': preferences?.toJson(),
    };
  }
}

class UserPreferences {
  final String? preferredVoice;
  final int? fontSize;
  final bool? autoPlay;
  final List<String>? favoriteCategories;
  final List<String>? favoriteKeywords;
  final List<String>? favoriteMedia; // 관심 언론사 추가

  UserPreferences({
    this.preferredVoice,
    this.fontSize,
    this.autoPlay,
    this.favoriteCategories,
    this.favoriteKeywords,
    this.favoriteMedia,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      preferredVoice: json['preferredVoice'],
      fontSize: json['fontSize'],
      autoPlay: json['autoPlay'],
      favoriteCategories: json['favoriteCategories'] != null
          ? List<String>.from(json['favoriteCategories'])
          : null,
      favoriteKeywords: json['favoriteKeywords'] != null
          ? List<String>.from(json['favoriteKeywords'])
          : null,
      favoriteMedia: json['favoriteMedia'] != null
          ? List<String>.from(json['favoriteMedia'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferredVoice': preferredVoice,
      'fontSize': fontSize,
      'autoPlay': autoPlay,
      'favoriteCategories': favoriteCategories,
      'favoriteKeywords': favoriteKeywords,
      'favoriteMedia': favoriteMedia,
    };
  }
}

class UpdateUserRequest {
  final String? nickname;
  final String? profileImage;
  final String? phoneNumber;
  final UserPreferences? preferences;

  UpdateUserRequest({
    this.nickname,
    this.profileImage,
    this.phoneNumber,
    this.preferences,
  });

  Map<String, dynamic> toJson() {
    return {
      if (nickname != null) 'nickname': nickname,
      if (profileImage != null) 'profileImage': profileImage,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (preferences != null) 'preferences': preferences!.toJson(),
    };
  }
}
