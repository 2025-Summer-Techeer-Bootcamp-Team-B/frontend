import 'package:flutter/material.dart';
import 'screens/favorites/fav_s_t_off.dart';
import 'screens/favorites/favorites_screen_toggle_on.dart';
import 'screens/home/home_screen.dart';
import 'screens/briefing/bri_playlist.dart';
// import 'screens/home/dfs.dart';
// import 'screens/favorites/favorites_screen_toggle_off.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '즐겨찾기 데모',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Pretendard',
      ),
      home: const BriPlaylistScreen(),
    );
  }
}
