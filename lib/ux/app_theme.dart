import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    _saveTheme(isOn);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> _saveTheme(bool isOn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isOn);
  }
}
