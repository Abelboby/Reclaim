import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;
  
  ThemeMode _themeMode;
  
  ThemeMode get themeMode => _themeMode;

  ThemeProvider(this._prefs) : _themeMode = ThemeMode.values[_prefs.getInt(_themeKey) ?? ThemeMode.system.index] {
    _loadTheme();
  }

  void _loadTheme() {
    final savedThemeIndex = _prefs.getInt(_themeKey);
    if (savedThemeIndex != null) {
      _themeMode = ThemeMode.values[savedThemeIndex];
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt(_themeKey, mode.index);
    notifyListeners();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;
} 