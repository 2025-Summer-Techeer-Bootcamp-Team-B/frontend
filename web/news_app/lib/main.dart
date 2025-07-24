import 'package:flutter/material.dart';
import 'screens/history/history_list_screen.dart';
import 'screens/favorites/favorites_screen_toggle_off.dart';
import 'screens/favorites/dfsd.dart';
import 'screens/history/history_click_screen.dart';
import 'screens/history/history_list_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/settings/contents_setting/keyword_edit.dart';
import 'screens/settings/contents_setting/media_edit.dart';
import 'screens/settings/setting_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FavoritesScreenToggleOff(),
    );
  }
}
