import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.oceanBlue,
        onPrimary: Colors.white,
        secondary: AppColors.turquoise,
        onSecondary: AppColors.darkTeal,
        tertiary: AppColors.turquoise,
        onTertiary: Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        background: AppColors.mintWhite,
        onBackground: AppColors.darkTeal,
        surface: Colors.white,
        onSurface: AppColors.darkTeal,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.mintWhite,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkTeal),
        bodyMedium: TextStyle(color: AppColors.darkTeal),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.oceanBlue,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.turquoise,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.turquoise,
        onPrimary: Colors.white,
        secondary: AppColors.oceanBlue,
        onSecondary: Colors.white,
        tertiary: AppColors.turquoise,
        onTertiary: Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        background: AppColors.darkBackground,
        onBackground: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: Colors.white,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.turquoise,
        foregroundColor: Colors.white,
      ),
    );
  }
} 