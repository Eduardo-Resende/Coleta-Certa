import 'package:flutter/material.dart';
import 'theme_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: ThemeColors.lightBackground,
      primaryColor: ThemeColors.lightPrimary,
      cardColor: ThemeColors.lightCard,
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeColors.lightPrimary,
        foregroundColor: ThemeColors.lightText,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: ThemeColors.lightText),
        bodyMedium: TextStyle(color: ThemeColors.lightText),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ThemeColors.darkBackground,
      primaryColor: ThemeColors.darkPrimary,
      cardColor: ThemeColors.darkCard,
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeColors.darkPrimary,
        foregroundColor: ThemeColors.darkText,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: ThemeColors.darkText),
        bodyMedium: TextStyle(color: ThemeColors.darkText),
      ),
    );
  }
}
