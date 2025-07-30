import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/favorites/fav_s_t_off.dart';
import 'screens/favorites/fav_s_t_on.dart';
import 'screens/home/home_screen.dart';
import 'screens/briefing/bri_playlist.dart';
import 'screens/briefing/briefing_screen.dart';
import 'screens/auth/interest/keyword_select.dart';
import 'screens/auth/interest/media_select.dart';
import 'screens/settings/contents_setting/keyword_edit.dart';
import 'screens/settings/contents_setting/media_edit.dart';
import 'screens/settings/setting_screen.dart';
import 'screens/history/history_click_screen.dart';
import 'screens/history/history_list_screen.dart';
import 'services/api_service.dart';
import 'providers/user_preferences_provider.dart';
import 'providers/user_keyword_provider.dart';
import 'providers/user_voice_type_provider.dart';
import 'widgets/user_preferences_example.dart';
import 'widgets/user_keyword_example.dart';
import 'screens/auth/interest/voice_select.dart';
import 'screens/test_api_screen.dart';
import 'screens/auth/login_screen.dart';
import 'providers/tts_provider.dart';
import 'screens/auth/onboarding.dart';
import 'screens/auth/start_screen.dart';
// import 'screens/home/dfs.dart';
// import 'screens/favorites/favorites_screen_toggle_off.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService().initialize();
  
  // UserPreferencesProvider 초기화
  final userPreferencesProvider = UserPreferencesProvider();
  await userPreferencesProvider.loadUserPreferences();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TtsProvider()),
        ChangeNotifierProvider(create: (_) => UserVoiceTypeProvider()),
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()),
        // 기존 Provider들...
      ],
      child: MaterialApp(
        title: '뉴스 브리핑 앱',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Pretendard',
        ),
        home: const StartScreen(), // 온보딩 없이 바로 시작화면으로 진입
      ),
    );
  }
}
