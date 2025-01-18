import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/sobriety_data.dart';

class SobrietyProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  SobrietyData? _data;

  SobrietyProvider(this._prefs) {
    _loadData();
  }

  SobrietyData? get data => _data;

  void _loadData() {
    final jsonStr = _prefs.getString('sobriety_data');
    if (jsonStr != null) {
      _data = SobrietyData.fromJson(jsonDecode(jsonStr));
    } else {
      _data = SobrietyData.initial();
      _saveData();
    }
    notifyListeners();
  }

  void _saveData() {
    if (_data != null) {
      _prefs.setString('sobriety_data', jsonEncode(_data!.toJson()));
    }
  }

  Future<void> checkIn() async {
    if (_data == null) return;

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (!_data!.checkIns.contains(today)) {
      final checkIns = List<DateTime>.from(_data!.checkIns)..add(today);
      int currentStreak = _calculateCurrentStreak(checkIns);
      int longestStreak = currentStreak > _data!.longestStreak
          ? currentStreak
          : _data!.longestStreak;

      final achievements = Map<String, bool>.from(_data!.achievements);
      _updateAchievements(achievements, currentStreak);

      _data = SobrietyData(
        startDate: _data!.startDate,
        checkIns: checkIns,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        achievements: achievements,
      );

      _saveData();
      notifyListeners();
    }
  }

  int _calculateCurrentStreak(List<DateTime> checkIns) {
    if (checkIns.isEmpty) return 0;

    checkIns.sort((a, b) => b.compareTo(a));
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (!checkIns.contains(today)) return 0;

    int streak = 1;
    DateTime lastDate = today;

    for (int i = 0; i < checkIns.length; i++) {
      final currentDate = DateTime(
        checkIns[i].year,
        checkIns[i].month,
        checkIns[i].day,
      );

      if (currentDate.isAtSameMomentAs(lastDate)) continue;

      final difference = lastDate.difference(currentDate).inDays;
      if (difference == 1) {
        streak++;
        lastDate = currentDate;
      } else {
        break;
      }
    }

    return streak;
  }

  void _updateAchievements(Map<String, bool> achievements, int currentStreak) {
    if (currentStreak >= 7) achievements['one_week'] = true;
    if (currentStreak >= 30) achievements['one_month'] = true;
    if (currentStreak >= 90) achievements['three_months'] = true;
    if (currentStreak >= 180) achievements['six_months'] = true;
    if (currentStreak >= 365) achievements['one_year'] = true;
  }

  void reset() {
    _data = SobrietyData.initial();
    _saveData();
    notifyListeners();
  }

  bool get hasCheckedInToday {
    if (_data == null) return false;
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return _data!.checkIns.contains(today);
  }
}
