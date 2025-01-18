import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/providers/sobriety_provider.dart';
import '../../../core/models/sobriety_data.dart';
import 'dart:math' show pi;

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
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
                  SliverAppBar(
                    expandedHeight: 200,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text('Day ${data.currentStreak}'),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStreakCard(data),
                          const SizedBox(height: 16),
                          _buildAchievements(data),
                          const SizedBox(height: 16),
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
                  blastDirection: pi / 2,
                  maxBlastForce: 5,
                  minBlastForce: 2,
                  emissionFrequency: 0.05,
                  numberOfParticles: 50,
                  gravity: 0.1,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleCheckIn(context),
        label: const Text('Check In'),
        icon: const Icon(Icons.check),
      ),
    );
  }

  Widget _buildStreakCard(SobrietyData data) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStreakInfo('Current Streak', data.currentStreak),
                _buildStreakInfo('Longest Streak', data.longestStreak),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: data.currentStreak / 30, // Progress towards monthly goal
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '${30 - data.currentStreak} days to next milestone',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakInfo(String label, int days) {
    return Column(
      children: [
        Text(
          days.toString(),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildAchievements(SobrietyData data) {
    final achievements = {
      'first_day': ['First Day', Icons.start],
      'one_week': ['One Week', Icons.calendar_today],
      'one_month': ['One Month', Icons.event_available],
      'three_months': ['Three Months', Icons.emoji_events],
      'six_months': ['Six Months', Icons.military_tech],
      'one_year': ['One Year', Icons.workspace_premium],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements.entries.elementAt(index);
              final isUnlocked = data.achievements[achievement.key] ?? false;
              return Card(
                color: isUnlocked
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).disabledColor,
                child: SizedBox(
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        achievement.value[1] as IconData,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.value[0] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar(SobrietyData data) {
    return Card(
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
        ),
        calendarStyle: CalendarStyle(
          markerDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  void _handleCheckIn(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Check-in'),
        content: const Text('Confirm your sobriety check-in for today?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confettiController.play();
              context.read<SobrietyProvider>().checkIn();
            },
            child: const Text('Check In'),
          ),
        ],
      ),
    );
  }
} 