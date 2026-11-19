import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'core/theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: AppTheme.themeData, home: const HomePage());
  }
}
