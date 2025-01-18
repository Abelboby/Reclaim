import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/providers/sobriety_provider.dart';
import '../../../core/models/sobriety_data.dart';
import '../../../core/constants/app_colors.dart';
import 'dart:math' show pi;

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SobrietyProvider>(
        builder: (context, provider, child) {
          final data = provider.data;
          if (data == null) return const Center(child: CircularProgressIndicator());

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _buildAppBar(data),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStreakCard(data),
                          const SizedBox(height: 24),
                          _buildAchievements(data),
                          const SizedBox(height: 24),
                          _buildCalendar(data),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  maxBlastForce: 7,
                  minBlastForce: 3,
                  emissionFrequency: 0.05,
                  numberOfParticles: 50,
                  gravity: 0.1,
                  colors: const [
                    AppColors.turquoise,
                    AppColors.oceanBlue,
                    Colors.purple,
                    Colors.pink,
                    Colors.white,
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<SobrietyProvider>(
        builder: (context, provider, child) => FadeTransition(
          opacity: _animation,
          child: FloatingActionButton.extended(
            onPressed: provider.hasCheckedInToday ? null : () => _handleCheckIn(context),
            backgroundColor: provider.hasCheckedInToday 
                ? Colors.grey 
                : AppColors.turquoise,
            icon: Icon(
              provider.hasCheckedInToday ? Icons.check_circle : Icons.add_task,
              color: provider.hasCheckedInToday ? Colors.white54 : Colors.white,
            ),
            label: Text(
              provider.hasCheckedInToday ? 'Checked In' : 'Daily Check-in',
              style: TextStyle(
                color: provider.hasCheckedInToday ? Colors.white54 : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(SobrietyData data) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '${data.currentStreak} Days Strong',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.oceanBlue,
                AppColors.turquoise.withOpacity(0.8),
              ],
            ),
          ),
          child: FadeTransition(
            opacity: _animation,
            child: Center(
              child: Icon(
                Icons.emoji_events,
                size: 80,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard(SobrietyData data) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).cardColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStreakInfo('Current Streak', data.currentStreak, Icons.local_fire_department),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  _buildStreakInfo('Longest Streak', data.longestStreak, Icons.star),
                ],
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(_animation),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: data.currentStreak / 30,
                      minHeight: 10,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.turquoise),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${30 - data.currentStreak} days to next milestone',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakInfo(String label, int days, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              days.toString(),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.oceanBlue,
                  ),
            ),
            const SizedBox(width: 4),
            Icon(icon, color: AppColors.turquoise),
          ],
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildAchievements(SobrietyData data) {
    final achievements = {
      'first_day': ['First Step', Icons.emoji_events, 'Beginning of your journey'],
      'one_week': ['One Week', Icons.calendar_today, '7 days milestone'],
      'one_month': ['One Month', Icons.event_available, '30 days strong'],
      'three_months': ['3 Months', Icons.psychology, '90 days of strength'],
      'six_months': ['6 Months', Icons.military_tech, 'Half year warrior'],
      'one_year': ['1 Year', Icons.workspace_premium, 'Full year champion'],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements.entries.elementAt(index);
              final isUnlocked = data.achievements[achievement.key] ?? false;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: ScaleTransition(
                  scale: _animation,
                  child: _buildAchievementCard(
                    title: achievement.value[0] as String,
                    icon: achievement.value[1] as IconData,
                    description: achievement.value[2] as String,
                    isUnlocked: isUnlocked,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard({
    required String title,
    required IconData icon,
    required String description,
    required bool isUnlocked,
  }) {
    return Card(
      elevation: isUnlocked ? 8 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: isUnlocked
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.oceanBlue,
                    AppColors.turquoise,
                  ],
                )
              : null,
          color: isUnlocked ? null : Colors.grey.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isUnlocked ? Colors.white : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? Colors.white : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isUnlocked ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(SobrietyData data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: data.startDate,
          lastDay: DateTime.now(),
          focusedDay: DateTime.now(),
          calendarFormat: CalendarFormat.month,
          eventLoader: (day) {
            return data.checkIns.contains(DateTime(
              day.year,
              day.month,
              day.day,
            ))
                ? [true]
                : [];
          },
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          calendarStyle: CalendarStyle(
            markerDecoration: BoxDecoration(
              color: AppColors.turquoise,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: AppColors.oceanBlue.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.oceanBlue,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  void _handleCheckIn(BuildContext context) {
    final provider = context.read<SobrietyProvider>();
    if (provider.hasCheckedInToday) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You\'ve already checked in today. Keep going strong!'),
          backgroundColor: AppColors.oceanBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Daily Check-in'),
        content: const Text(
          'Confirm your sobriety check-in for today?\nStay strong, you\'re doing great!',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confettiController.play();
              provider.checkIn();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.turquoise,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Check In'),
          ),
        ],
      ),
    );
  }
} 