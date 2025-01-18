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
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.oceanBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(color: Colors.black87),
        titleMedium: TextStyle(color: Colors.black87),
      ),
      useMaterial3: true,
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
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkTeal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
      ),
      useMaterial3: true,
    );
  }
} 