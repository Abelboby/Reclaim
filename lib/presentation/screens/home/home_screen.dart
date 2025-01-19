import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../tracker/tracker_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/sobriety_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/animations/app_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animations = List.generate(
      5,
      (index) => CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.1,
          0.6 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  final userName =
                      authProvider.user?.displayName?.split(' ')[0] ?? 'User';
                  return Text(
                    'Welcome back,\n$userName',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppAnimations.shimmer(
                      child: Icon(
                        Icons.waves,
                        size: 120,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.oceanBlue.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  AppAnimations.slideUp(
                    animation: _animations[0],
                    child: _buildCurrentStreak(context),
                  ),
                  const SizedBox(height: 32),
                  AppAnimations.slideUp(
                    animation: _animations[1],
                    child: _buildMotivationalQuote(),
                  ),
                  const SizedBox(height: 32),
                  AppAnimations.slideUp(
                    animation: _animations[2],
                    child: _buildTrackProgressButton(context),
                  ),
                  const SizedBox(height: 32),
                  AppAnimations.slideUp(
                    animation: _animations[3],
                    child: _buildNextMilestone(),
                  ),
                  const SizedBox(height: 32),
                  AppAnimations.slideUp(
                    animation: _animations[4],
                    child: _buildEmergencyContact(),
                  ),
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

        return Hero(
          tag: 'streak_card',
          child: Card(
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
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.oceanBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          TweenAnimationBuilder<int>(
                            duration: const Duration(seconds: 1),
                            tween: IntTween(begin: 0, end: data.currentStreak),
                            builder: (context, value, child) {
                              return Text(
                                '$value',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: AppColors.oceanBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                              );
                            },
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'days',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.oceanBlue.withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Icon(
                      Icons.local_fire_department,
                      color: AppColors.oceanBlue,
                      size: 48,
                    ),
                  ),
                ],
              ),
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
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: (1 - value) * 0.5,
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: const Icon(
                Icons.format_quote,
                color: AppColors.turquoise,
                size: 32,
              ),
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
    return Hero(
      tag: 'track_progress',
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                AppAnimations.fadeScale(child: const TrackerScreen()),
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
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: (1 - value) * 2,
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons.flag,
                    color: AppColors.oceanBlue,
                    size: 24,
                  ),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            try {
              if (!context.mounted) return;

              final phoneNumber = 'tel:18006624357';
              final uri = Uri.parse(phoneNumber);
              await launchUrl(
                uri,
                mode: LaunchMode.platformDefault,
              );
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                  ),
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.5 + (value * 0.5),
                      child: child,
                    );
                  },
                  child: Container(
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
                        '1-800-662-4357',
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
        ),
      ),
    );
  }
}
