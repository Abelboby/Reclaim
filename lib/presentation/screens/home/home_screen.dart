import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../tracker/tracker_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/sobriety_provider.dart';
import '../../../core/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  final userName = authProvider.user?.displayName?.split(' ')[0] ?? 'User';
                  return Text(
                    'Welcome back, $userName',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColors.oceanBlue,
                      AppColors.turquoise,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildCurrentStreak(context),
                  const SizedBox(height: 32),
                  _buildMotivationalQuote(),
                  const SizedBox(height: 32),
                  _buildTrackProgressButton(context),
                  const SizedBox(height: 32),
                  _buildNextMilestone(),
                  const SizedBox(height: 32),
                  _buildEmergencyContact(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStreak(BuildContext context) {
    return Consumer<SobrietyProvider>(
      builder: (context, provider, _) {
        final data = provider.data;
        if (data == null) return const SizedBox.shrink();

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: AppColors.oceanBlue.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Streak',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.oceanBlue,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${data.currentStreak}',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: AppColors.oceanBlue,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'days',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.oceanBlue.withOpacity(0.7),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.local_fire_department,
                  color: AppColors.oceanBlue,
                  size: 48,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMotivationalQuote() {
    return Card(
      elevation: 0,
      color: AppColors.turquoise.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.format_quote,
              color: AppColors.turquoise,
              size: 32,
            ),
            const SizedBox(height: 16),
            Text(
              'Recovery is not a race. You don\'t have to feel guilty if it takes you longer than you thought it would.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackProgressButton(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TrackerScreen()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.oceanBlue,
                AppColors.turquoise,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.trending_up,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Track Your Progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Log your daily journey and see your growth',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextMilestone() {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flag,
                  color: AppColors.oceanBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Next Milestone',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<SobrietyProvider>(
              builder: (context, provider, _) {
                final data = provider.data;
                if (data == null) return const SizedBox.shrink();

                final nextMilestone = (data.currentStreak ~/ 30 + 1) * 30;
                final daysLeft = nextMilestone - data.currentStreak;

                return Text(
                  '$daysLeft days until $nextMilestone day milestone',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContact() {
    return Card(
      elevation: 0,
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone,
                color: Colors.red.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need immediate help?',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Call 1-800-662-4357',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 