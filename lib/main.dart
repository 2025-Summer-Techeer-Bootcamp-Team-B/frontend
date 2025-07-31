import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'providers/user_preferences_provider.dart';
import 'providers/user_voice_type_provider.dart';
import 'providers/user_keyword_provider.dart';
import 'providers/tts_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/history_provider.dart';
import 'providers/user_info_provider.dart';
import 'screens/auth/onboarding.dart';
// import 'screens/home/dfs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 앱을 먼저 실행하고, 초기화는 백그라운드에서 진행
  runApp(const MyApp());
  
  // 백그라운드에서 초기화 작업 수행
  _initializeApp();
}

Future<void> _initializeApp() async {
  try {
    // API 서버가 실행되지 않은 경우를 위해 try-catch로 감싸기
    await ApiService().initialize();
  } catch (e) {
    print('API 서버 연결 실패 (무시됨): $e');
  }
  
  try {
    // UserPreferencesProvider 초기화
    final userPreferencesProvider = UserPreferencesProvider();
    await userPreferencesProvider.loadUserPreferences();
  } catch (e) {
    print('사용자 설정 로드 실패: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 앱 시작 시 데이터 로드는 MaterialApp이 빌드된 후에 수행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStoredData();
    });
  }

  Future<void> _loadStoredData() async {
    // Provider 인스턴스 가져오기
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    
    // 저장된 데이터 로드
    await favoritesProvider.loadFromStorage();
    await historyProvider.loadFromStorage();
    await userInfoProvider.loadFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TtsProvider()),
        ChangeNotifierProvider(create: (_) => UserVoiceTypeProvider()),
        ChangeNotifierProvider(create: (_) => UserKeywordProvider()),
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => UserInfoProvider()),
        // 기존 Provider들...
      ],
      child: MaterialApp(
        title: '뉴스 브리핑 앱',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Pretendard',
        ),
        home: const OnboardingScreen(), // 온보딩 화면에서 시작
      ),
    );
  }
}
