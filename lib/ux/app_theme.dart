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
      colorScheme: ColorScheme.light(
        primary: ThemeColors.lightPrimary,
        onPrimary: Colors.white,
        secondary: Colors.greenAccent,
        onSecondary: Colors.black,
        surface: ThemeColors.lightBackground,
        onSurface: ThemeColors.lightText,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.lightPrimary),
        ),
        labelStyle: TextStyle(color: ThemeColors.lightPrimary),
        floatingLabelStyle: TextStyle(color: ThemeColors.lightPrimary),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: ThemeColors.lightPrimary,
      ),
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
      colorScheme: ColorScheme.dark(
        primary: ThemeColors.darkPrimary,
        onPrimary: Colors.black,
        secondary: Colors.greenAccent,
        onSecondary: Colors.white,
        surface: ThemeColors.darkBackground,
        onSurface: ThemeColors.darkText,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.darkPrimary),
        ),
        labelStyle: TextStyle(color: ThemeColors.darkPrimary),
        floatingLabelStyle: TextStyle(color: ThemeColors.darkPrimary),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: ThemeColors.darkPrimary,
      ),
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
