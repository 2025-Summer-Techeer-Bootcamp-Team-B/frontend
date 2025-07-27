# API 연동 가이드

## 📁 파일 구조

```
lib/
├── models/
│   ├── common_models.dart      # 공통 응답 모델들
│   ├── auth_models.dart        # 인증 관련 모델들
│   ├── user_models.dart        # 사용자 관련 모델들
│   └── article_models.dart     # 뉴스/기사 관련 모델들
├── services/
│   ├── api_service.dart        # Dio 기반 HTTP 클라이언트
│   ├── auth_service.dart       # 인증 관련 API
│   ├── user_service.dart       # 사용자 관련 API
│   └── news_service.dart       # 뉴스 관련 API
└── screens/
    └── auth/
        └── login_screen.dart   # 로그인 화면 (API 연동 예시)
```

## 🚀 시작하기

### 1. API 서비스 초기화
`main.dart`에서 이미 초기화되어 있습니다:
```dart
void main() {
  ApiService().initialize();
  runApp(const MyApp());
}
```

### 2. 백엔드 URL 설정
`services/api_service.dart`에서 실제 백엔드 URL로 변경:
```dart
static const String baseUrl = 'https://your-backend-url.com/api';
```

## 📝 사용 예시

### 로그인 API 호출
```dart
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  // ...
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool isLoading = false;

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      // API 호출
      final authResponse = await _authService.login(email, password);
      
      print('로그인 성공: ${authResponse.user.nickname}');
      print('토큰: ${authResponse.accessToken}');
      
      // 로그인 성공 시 다음 화면으로 이동
      Navigator.pushReplacement(context, ...);
      
    } catch (e) {
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 실패했습니다: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
```

### 뉴스 API 호출
```dart
import '../../services/news_service.dart';

class HomeScreen extends StatefulWidget {
  // ...
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();
  List<ArticleModel> breakingNews = [];

  @override
  void initState() {
    super.initState();
    _loadBreakingNews();
  }

  Future<void> _loadBreakingNews() async {
    try {
      final news = await _newsService.getBreakingNews();
      setState(() {
        breakingNews = news;
      });
    } catch (e) {
      print('뉴스 로딩 실패: $e');
    }
  }
}
```

### 사용자 프로필 API 호출
```dart
import '../../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  // ...
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  UserModel? userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _userService.getUserProfile();
      setState(() {
        userProfile = profile;
      });
    } catch (e) {
      print('프로필 로딩 실패: $e');
    }
  }
}
```

## 🔧 주요 기능

### 1. 자동 토큰 관리
- 로그인 시 자동으로 토큰이 저장됩니다
- 모든 API 요청에 자동으로 Authorization 헤더가 추가됩니다
- 401 에러 시 토큰 갱신 로직이 준비되어 있습니다

### 2. 에러 처리
- 네트워크 오류, 서버 오류 등 모든 에러가 적절히 처리됩니다
- 사용자 친화적인 에러 메시지가 표시됩니다

### 3. 로딩 상태 관리
- API 호출 중 로딩 상태를 표시할 수 있습니다
- 중복 요청을 방지합니다

## 📋 API 엔드포인트

### 인증 관련
- `POST /auth/login` - 로그인
- `POST /auth/signup` - 회원가입
- `POST /auth/refresh` - 토큰 갱신
- `POST /auth/logout` - 로그아웃
- `GET /auth/check-email` - 이메일 중복 확인

### 사용자 관련
- `GET /users/profile` - 프로필 조회
- `PATCH /users/profile` - 프로필 수정
- `POST /users/change-password` - 비밀번호 변경
- `GET /users/categories` - 사용자 카테고리 조회
- `PUT /users/categories` - 사용자 카테고리 수정
- `GET /users/keywords` - 사용자 키워드 조회
- `PUT /users/keywords` - 사용자 키워드 수정

### 뉴스 관련
- `GET /news/breaking` - 실시간 속보
- `GET /news/today` - 오늘의 뉴스
- `GET /news/category` - 카테고리별 뉴스
- `GET /news/keyword` - 키워드별 뉴스
- `GET /news/{id}` - 뉴스 상세
- `GET /news/search` - 뉴스 검색

### 즐겨찾기/기록 관련
- `GET /favorites` - 즐겨찾기 목록
- `POST /favorites/add` - 즐겨찾기 추가
- `DELETE /favorites/remove/{id}` - 즐겨찾기 제거
- `GET /history` - 재생 기록
- `POST /history/add` - 재생 기록 추가

## 🎯 다음 단계

1. **백엔드 URL 설정**: 실제 백엔드가 배포되면 URL을 변경하세요
2. **토큰 저장**: SharedPreferences를 사용하여 토큰을 로컬에 저장하세요
3. **에러 처리 개선**: 더 구체적인 에러 메시지를 추가하세요
4. **캐싱**: 자주 사용되는 데이터를 캐싱하세요
5. **오프라인 지원**: 네트워크 없을 때의 처리를 추가하세요

## ❓ 문제 해결

### Q: API 호출이 실패해요
A: 다음을 확인해보세요:
- 백엔드 URL이 올바른지
- 네트워크 연결이 정상인지
- API 엔드포인트가 올바른지
- 요청 데이터 형식이 맞는지

### Q: 토큰이 자동으로 추가되지 않아요
A: 로그인 후 `AuthService.setToken()`을 호출했는지 확인하세요.

### Q: 에러 메시지가 너무 일반적이에요
A: `api_service.dart`의 `_handleError` 메서드를 수정하여 더 구체적인 메시지를 추가하세요. 