import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/features/main_page/main_screen_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MainScreenPage());
  }
}
