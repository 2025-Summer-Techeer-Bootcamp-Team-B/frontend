import 'package:flutter/material.dart';
import 'screens/history/history_list_screen.dart';
import 'screens/favorites/favorites_screen_toggle_off.dart';

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
