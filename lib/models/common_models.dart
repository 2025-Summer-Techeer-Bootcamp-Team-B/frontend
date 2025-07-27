// 공통 응답 모델들
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      statusCode: json['statusCode'],
    );
  }
}

class ErrorResponse {
  final String message;
  final String? error;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ErrorResponse({
    required this.message,
    this.error,
    this.statusCode,
    this.errors,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] ?? '알 수 없는 오류가 발생했습니다.',
      error: json['error'],
      statusCode: json['statusCode'],
      errors: json['errors'] != null
          ? Map<String, dynamic>.from(json['errors'])
          : null,
    );
  }
}

class PaginationInfo {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNext;
  final bool hasPrev;

  PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 10,
      hasNext: json['hasNext'] ?? false,
      hasPrev: json['hasPrev'] ?? false,
    );
  }
}

// 사용자 설정 모델
class UserPreferences {
  final List<String>? press;        // 관심 언론사
  final List<String>? category;     // 관심 카테고리
  final List<String>? keyword;      // 관심 키워드
  final String? voiceType;          // TTS 음성 타입
  final int? fontSize;              // 폰트 크기
  final bool? autoPlay;             // 자동재생 여부

  UserPreferences({
    this.press,
    this.category,
    this.keyword,
    this.voiceType,
    this.fontSize,
    this.autoPlay,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      press: json['press'] != null 
          ? List<String>.from(json['press'])
          : null,
      category: json['category'] != null 
          ? List<String>.from(json['category'])
          : null,
      keyword: json['keyword'] != null 
          ? List<String>.from(json['keyword'])
          : null,
      voiceType: json['voice_type'],
      fontSize: json['font_size'],
      autoPlay: json['auto_play'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'press': press,
      'category': category,
      'keyword': keyword,
      'voice_type': voiceType,
      'font_size': fontSize,
      'auto_play': autoPlay,
    };
  }

  // 편의 메서드들
  List<String> get favoriteMedia => press ?? [];
  List<String> get favoriteCategories => category ?? [];
  List<String> get favoriteKeywords => keyword ?? [];
  String get preferredVoice => voiceType ?? '';

  // 복사 메서드
  UserPreferences copyWith({
    List<String>? press,
    List<String>? category,
    List<String>? keyword,
    String? voiceType,
    int? fontSize,
    bool? autoPlay,
  }) {
    return UserPreferences(
      press: press ?? this.press,
      category: category ?? this.category,
      keyword: keyword ?? this.keyword,
      voiceType: voiceType ?? this.voiceType,
      fontSize: fontSize ?? this.fontSize,
      autoPlay: autoPlay ?? this.autoPlay,
    );
  }

  @override
  String toString() {
    return 'UserPreferences(press: $press, category: $category, keyword: $keyword, voiceType: $voiceType, fontSize: $fontSize, autoPlay: $autoPlay)';
  }
}

// 사용자 관심 키워드 모델
class UserKeywords {
  final List<String> keywords;

  UserKeywords({
    required this.keywords,
  });

  factory UserKeywords.fromJson(Map<String, dynamic> json) {
    return UserKeywords(
      keywords: json['keywords'] != null 
          ? List<String>.from(json['keywords'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keywords': keywords,
    };
  }

  @override
  String toString() {
    return 'UserKeywords(keywords: $keywords)';
  }
}

// 사용자 TTS 음성 타입 모델
class UserVoiceType {
  final String voiceType;  // 'male' 또는 'female'

  UserVoiceType({
    required this.voiceType,
  });

  factory UserVoiceType.fromJson(Map<String, dynamic> json) {
    return UserVoiceType(
      voiceType: json['voice_type'] ?? 'male', // 기본값은 남성
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voice_type': voiceType,
    };
  }

  // 편의 메서드
  bool get isMale => voiceType == 'male';
  bool get isFemale => voiceType == 'female';
  String get displayName => isMale ? '남성' : '여성';

  // 복사 메서드
  UserVoiceType copyWith({
    String? voiceType,
  }) {
    return UserVoiceType(
      voiceType: voiceType ?? this.voiceType,
    );
  }

  @override
  String toString() {
    return 'UserVoiceType(voiceType: $voiceType)';
  }
}

// 사용자 관심 키워드 모델
class UserKeyword {
  final List<String>? keyword;      // 관심 키워드

  UserKeyword({
    this.keyword,
  });

  factory UserKeyword.fromJson(Map<String, dynamic> json) {
    return UserKeyword(
      keyword: json['keyword'] != null 
          ? List<String>.from(json['keyword'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
    };
  }

  // 편의 메서드
  List<String> get keywords => keyword ?? [];

  // 복사 메서드
  UserKeyword copyWith({
    List<String>? keyword,
  }) {
    return UserKeyword(
      keyword: keyword ?? this.keyword,
    );
  }

  @override
  String toString() {
    return 'UserKeyword(keyword: $keyword)';
  }
}

// 사용자 관심 카테고리 모델
class UserCategories {
  final List<String>? category;      // 관심 카테고리

  UserCategories({
    this.category,
  });

  factory UserCategories.fromJson(Map<String, dynamic> json) {
    return UserCategories(
      category: json['category'] != null 
          ? List<String>.from(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
    };
  }

  // 편의 메서드
  List<String> get categories => category ?? [];

  // 복사 메서드
  UserCategories copyWith({
    List<String>? category,
  }) {
    return UserCategories(
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'UserCategories(category: $category)';
  }
}

// 사용자 관심 언론사 모델
class UserPress {
  final List<String>? press;      // 관심 언론사

  UserPress({
    this.press,
  });

  factory UserPress.fromJson(Map<String, dynamic> json) {
    return UserPress(
      press: json['press'] != null 
          ? List<String>.from(json['press'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'press': press,
    };
  }

  // 편의 메서드
  List<String> get pressList => press ?? [];

  // 복사 메서드
  UserPress copyWith({
    List<String>? press,
  }) {
    return UserPress(
      press: press ?? this.press,
    );
  }

  @override
  String toString() {
    return 'UserPress(press: $press)';
  }
}
