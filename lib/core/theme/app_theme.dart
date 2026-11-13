import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.green;
  static const Color secondaryColor = Colors.black;
  static const Color tertiaryColor = Colors.white;

  static ThemeData get themeData {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: tertiaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 32),
        bodyMedium: TextStyle(fontSize: 20),
        bodyLarge: TextStyle(fontSize: 24),
        bodySmall: TextStyle(fontSize: 16),
      ),
    );
  }
}
