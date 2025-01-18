import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/sobriety_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class SobrietyProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  SobrietyData? _data;
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  SobrietyProvider(this._prefs) {
    tz.initializeTimeZones();
    _loadData();
    _initializeNotifications();
  }

  SobrietyData? get data => _data;
  
  Future<void> _initializeNotifications() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _notifications.initialize(initializationSettings);
    _scheduleDaily();
  }

  Future<void> _scheduleDaily() async {
    await _notifications.zonedSchedule(
      0,
      'Daily Check-in Reminder',
      'Maintain your streak! Log your sobriety progress for today.',
      _nextInstance(),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'sobriety_tracker',
          'Sobriety Tracker',
          channelDescription: 'Daily check-in reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstance() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20, 0);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

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
    int streak = 1;
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (!checkIns.contains(today)) return 0;

    for (int i = 1; i < checkIns.length; i++) {
      final difference = checkIns[i - 1].difference(checkIns[i]).inDays;
      if (difference == 1) {
        streak++;
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
} 