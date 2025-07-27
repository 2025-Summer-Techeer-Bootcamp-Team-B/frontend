import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/favorites/fav_s_t_off.dart';
import 'screens/favorites/favorites_screen_toggle_on.dart';
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
// import 'screens/home/dfs.dart';
// import 'screens/favorites/favorites_screen_toggle_off.dart';

void main() {
  // API 서비스 초기화
  ApiService().initialize();

  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()),
        ChangeNotifierProvider(create: (_) => UserKeywordProvider()),
        ChangeNotifierProvider(create: (_) => UserVoiceTypeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '즐겨찾기 데모',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Pretendard',
        ),
        home: const UserPreferencesExample(), // 설정 화면으로 시작 (TTS 변경 테스트)
      ),
    );
  }
}
