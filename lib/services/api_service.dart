import 'package:dio/dio.dart';
import '../models/common_models.dart';
import '../models/auth_models.dart';
import '../models/article_models.dart';
import 'token_storage.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _accessToken;
  String? _refreshToken; // 리프레시 토큰 추가

  // TODO: 백엔드 배포 후 실제 URL로 변경
  static const String baseUrl = 'http://127.0.0.1:8000'; // 로컬 백엔드 서버

  Future<void> initialize() async {
    // 저장된 토큰들 불러오기
    await _loadTokens();
    
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // 요청 인터셉터 - 토큰 자동 추가
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        print('REQUEST DATA: ${options.data}');

        // 토큰이 있으면 헤더에 추가
        if (_accessToken != null) {
          options.headers['Authorization'] = 'Bearer $_accessToken';
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) async {
        print('ERROR[${error.response?.statusCode}] => ${error.message}');

        // 401 에러 시 토큰 갱신 시도
        if (error.response?.statusCode == 401 && _refreshToken != null) {
          try {
            // 토큰 갱신 요청
            final refreshRequest = RefreshTokenRequest(refreshToken: _refreshToken!);
            final refreshResponse = await _dio.post(
              ApiEndpoints.refreshToken,
              data: refreshRequest.toJson(),
            );
            
            final authResponse = AuthResponse.fromJson(refreshResponse.data);
            
            // 새 토큰들 저장 (메모리 + 영구 저장소)
            await setTokens(authResponse.accessToken ?? '', authResponse.refreshToken ?? '');
            
            // 새 토큰으로 원래 요청 재시도
            final originalRequest = error.requestOptions;
            originalRequest.headers['Authorization'] = 'Bearer ${authResponse.accessToken}';
            
            final response = await _dio.fetch(originalRequest);
            handler.resolve(response);
            return;
          } catch (refreshError) {
            // 토큰 갱신 실패 시 로그아웃 처리
            print('Token refresh failed: $refreshError');
            await clearTokens();
            // TODO: 로그인 화면으로 리다이렉트
          }
        }

        handler.next(error);
      },
    ));
  }

  // 저장된 토큰들 불러오기
  Future<void> _loadTokens() async {
    final tokens = await TokenStorage.getTokens();
    _accessToken = tokens['accessToken'];
    _refreshToken = tokens['refreshToken'];
  }

  // 액세스 토큰 설정
  void setAccessToken(String token) {
    _accessToken = token;
    TokenStorage.saveAccessToken(token);
  }

  // 리프레시 토큰 설정
  void setRefreshToken(String token) {
    _refreshToken = token;
    TokenStorage.saveRefreshToken(token);
  }

  // 토큰들 설정 (한번에)
  Future<void> setTokens(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await TokenStorage.saveTokens(accessToken, refreshToken);
  }

  // 토큰 제거
  void clearAccessToken() {
    _accessToken = null;
    TokenStorage.removeAccessToken();
  }

  // 모든 토큰 제거
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await TokenStorage.clearTokens();
  }

  // 토큰 상태 확인 (public getter)
  bool get hasAccessToken => _accessToken != null;
  bool get hasRefreshToken => _refreshToken != null;

  // GET 요청
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST 요청
  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT 요청
  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH 요청
  Future<Response> patch(String path, {dynamic data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE 요청
  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 사용자 설정 조회
  Future<UserPreferences> getUserPreferences() async {
    try {
      final response = await get(ApiEndpoints.userPress);
      return UserPreferences.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 사용자 관심 키워드 조회
  Future<UserKeywords> getUserKeywords() async {
    try {
      final response = await get(ApiEndpoints.userKeyword);
      return UserKeywords.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 사용자 TTS 음성 타입 조회
  Future<UserVoiceType> getUserVoiceType() async {
    try {
      final response = await get(ApiEndpoints.userVoiceType);
      return UserVoiceType.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 사용자 TTS 음성 타입 업데이트 (PUT)
  Future<UserPreferences> updateUserVoiceType(String voiceType) async {
    try {
      final requestData = {
        'voice_type': voiceType,
      };
      
      final response = await put(ApiEndpoints.userVoiceType, data: requestData);
      return UserPreferences.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 사용자 관심 카테고리 조회
  Future<UserCategories> getUserCategories() async {
    try {
      final response = await get(ApiEndpoints.userCategory);
      return UserCategories.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 사용자 관심 카테고리 저장 (POST - 새로 생성)
  Future<UserCategories> saveUserCategories(List<String> categories) async {
    try {
      final requestData = {
        'category': categories,
      };
      
      final response = await post(ApiEndpoints.userCategory, data: requestData);
      return UserCategories.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 사용자 관심 카테고리 업데이트 (PUT - 기존 데이터 수정)
  Future<UserCategories> updateUserCategories(List<String> categories) async {
    try {
      final requestData = {
        'category': categories,
      };
      
      final response = await put(ApiEndpoints.userCategory, data: requestData);
      return UserCategories.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 사용자 관심 언론사 조회
  Future<UserPress> getUserPress() async {
    try {
      final response = await get(ApiEndpoints.userPress);
      return UserPress.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 사용자 관심 언론사 업데이트 (PUT - 기존 데이터 수정)
  Future<UserPress> updateUserPress(List<String> press) async {
    try {
      final requestData = {
        'press': press,
      };
      
      final response = await put(ApiEndpoints.userPress, data: requestData);
      return UserPress.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 최신 기사 목록 조회 (recent)
  Future<List<ArticleModel>> fetchRecentArticles() async {
    try {
      final response = await get('/api/v1/articles/recent');
      final List<dynamic> data = response.data;
      return data.map((json) => ArticleModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 사용자 관심 카테고리 기사 조회
  Future<List<ArticleModel>> fetchPreferredCategoryArticles(String categoryName) async {
    try {
      final response = await get('/api/v1/articles/preferred-category', 
        queryParameters: {'category_name': categoryName});
      final List<dynamic> data = response.data;
      return data.map((json) => ArticleModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 에러 처리
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('네트워크 연결 시간이 초과되었습니다.');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final data = error.response?.data;

          if (data is Map<String, dynamic>) {
            final errorResponse = ErrorResponse.fromJson(data);
            return Exception(errorResponse.message);
          }

          switch (statusCode) {
            case 400:
              return Exception('잘못된 요청입니다.');
            case 401:
              return Exception('인증이 필요합니다.');
            case 403:
              return Exception('접근 권한이 없습니다.');
            case 404:
              return Exception('요청한 리소스를 찾을 수 없습니다.');
            case 422:
              return Exception('입력 데이터가 올바르지 않습니다.');
            case 500:
              return Exception('서버 오류가 발생했습니다.');
            default:
              return Exception(error.message ?? error.toString() ?? '알 수 없는 오류가 발생했습니다.');
          }
        case DioExceptionType.cancel:
          return Exception('요청이 취소되었습니다.');
        case DioExceptionType.connectionError:
          return Exception('네트워크 연결에 실패했습니다.');
        default:
          return Exception(error.message ?? error.toString() ?? '알 수 없는 오류가 발생했습니다.');
      }
    }
    return Exception(error.toString());
  }
}

// API 엔드포인트 상수
class ApiEndpoints {
  // 인증 관련
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String checkEmailDuplicate = '/auth/check-email';

  // 사용자 관련
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String changePassword = '/users/change-password';
  static const String userPreferences = '/users/preferences'; // 사용자 설정 추가
  static const String userPress = '/api/v1/user/press'; // 사용자 관심 언론사/카테고리/키워드 조회
  static const String userKeyword = '/api/v1/user/keyword'; // 사용자 관심 키워드 조회
  static const String userVoiceType = '/api/v1/user/voice-type'; // 사용자 TTS 음성 타입 조회
  static const String userCategory = '/api/v1/user/category'; // 사용자 관심 카테고리 조회/저장

  // 뉴스 관련
  static const String breakingNews = '/api/v1/articles/recent';
  static const String todayNews = '/news/today';
  static const String categoryNews = '/news/category';
  static const String keywordNews = '/news/keyword';
  static const String newsDetail = '/news';
  static const String searchNews = '/news/search';

  // 카테고리 관련
  static const String categories = '/categories';
  static const String userCategories = '/users/categories';

  // 키워드 관련
  static const String keywords = '/keywords';
  static const String userKeywords = '/users/keywords';

  // 즐겨찾기 관련
  static const String favorites = '/favorites';
  static const String addToFavorites = '/favorites/add';
  static const String removeFromFavorites = '/favorites/remove';

  // 재생 기록 관련
  static const String history = '/history';
  static const String addToHistory = '/history/add';

  // TTS 관련
  static const String tts = '/tts';
  static const String ttsVoices = '/tts/voices';

  // 채팅 관련
  static const String chat = '/chat';
  static const String chatHistory = '/chat/history';

  // 이미지 관련
  static const String uploadImage = '/images/upload';
}
