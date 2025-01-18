class SobrietyData {
  final DateTime startDate;
  final List<DateTime> checkIns;
  final int currentStreak;
  final int longestStreak;
  final Map<String, bool> achievements;

  SobrietyData({
    required this.startDate,
    required this.checkIns,
    required this.currentStreak,
    required this.longestStreak,
    required this.achievements,
  });

  Map<String, dynamic> toJson() => {
    'startDate': startDate.toIso8601String(),
    'checkIns': checkIns.map((date) => date.toIso8601String()).toList(),
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'achievements': achievements,
  };

  factory SobrietyData.fromJson(Map<String, dynamic> json) {
    return SobrietyData(
      startDate: DateTime.parse(json['startDate']),
      checkIns: (json['checkIns'] as List)
          .map((date) => DateTime.parse(date))
          .toList(),
      currentStreak: json['currentStreak'],
      longestStreak: json['longestStreak'],
      achievements: Map<String, bool>.from(json['achievements']),
    );
  }

  factory SobrietyData.initial() {
    return SobrietyData(
      startDate: DateTime.now(),
      checkIns: [DateTime.now()],
      currentStreak: 1,
      longestStreak: 1,
      achievements: {
        'first_day': true,
        'one_week': false,
        'one_month': false,
        'three_months': false,
        'six_months': false,
        'one_year': false,
      },
    );
  }
} 