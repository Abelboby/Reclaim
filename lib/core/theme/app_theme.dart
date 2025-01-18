import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryPurple,
        onPrimary: Colors.white,
        secondary: AppColors.sageGreen,
        onSecondary: Colors.white,
        tertiary: AppColors.softBlue,
        onTertiary: Colors.white,
        error: AppColors.coral,
        onError: Colors.white,
        background: AppColors.lightLavender,
        onBackground: AppColors.warmGray,
        surface: Colors.white,
        onSurface: AppColors.mutedTeal,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lightLavender,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.warmGray),
        bodyMedium: TextStyle(color: AppColors.warmGray),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.sageGreen,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.darkPrimaryVariant,
        onPrimary: Colors.white,
        secondary: AppColors.darkSecondaryVariant,
        onSecondary: Colors.white,
        tertiary: AppColors.softBlue,
        onTertiary: Colors.white,
        error: AppColors.coral,
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
        backgroundColor: AppColors.darkSecondaryVariant,
        foregroundColor: Colors.white,
      ),
    );
  }
} 