import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'dart:async';

class MindfulnessScreen extends StatefulWidget {
  const MindfulnessScreen({super.key});

  @override
  State<MindfulnessScreen> createState() => _MindfulnessScreenState();
}

class _MindfulnessScreenState extends State<MindfulnessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  Timer? _breathingTimer;
  String _breathingPhase = '';
  int _breathingCount = 0;
  bool _isBreathingActive = false;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _breathingTimer?.cancel();
    super.dispose();
  }

  void _startBreathingExercise(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BreathingExerciseSheet(
        type: type,
        onStart: () {
          Navigator.pop(context);
          _showBreathingOverlay();
        },
      ),
    );
  }

  void _showBreathingOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _BreathingOverlay(
        animation: _breathingAnimation,
        phase: _breathingPhase,
        count: _breathingCount,
        onClose: () {
          _stopBreathingExercise();
          Navigator.pop(context);
        },
      ),
    );
    _startBreathingAnimation();
  }

  void _startBreathingAnimation() {
    setState(() {
      _isBreathingActive = true;
      _breathingCount = 0;
      _breathingPhase = 'Inhale';
    });

    _breathingController.repeat(reverse: true);
    
    _breathingTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_isBreathingActive) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _breathingCount++;
        if (_breathingPhase == 'Inhale') {
          _breathingPhase = 'Hold';
        } else if (_breathingPhase == 'Hold') {
          _breathingPhase = 'Exhale';
        } else {
          _breathingPhase = 'Inhale';
        }
      });
    });
  }

  void _stopBreathingExercise() {
    setState(() {
      _isBreathingActive = false;
    });
    _breathingController.stop();
    _breathingTimer?.cancel();
  }

  void _showMeditationPlayer(String title, String duration) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MeditationPlayerSheet(
        title: title,
        duration: duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindfulness & Coping'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildMeditationSection(context),
            const SizedBox(height: 24),
            _buildBreathingExercises(context),
            const SizedBox(height: 24),
            _buildStressManagement(context),
            const SizedBox(height: 24),
            _buildSleepHygiene(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.oceanBlue.withOpacity(0.8),
            AppColors.turquoise.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.self_improvement,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            'Mindfulness Tools',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Practice these exercises to manage stress, anxiety, and cravings',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Guided Meditations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildMeditationCard(
                context,
                title: 'Craving Management',
                duration: '5 minutes',
                icon: Icons.waves,
                color: AppColors.oceanBlue,
              ),
              _buildMeditationCard(
                context,
                title: 'Stress Relief',
                duration: '10 minutes',
                icon: Icons.spa,
                color: AppColors.turquoise,
              ),
              _buildMeditationCard(
                context,
                title: 'Body Scan',
                duration: '15 minutes',
                icon: Icons.accessibility_new,
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeditationCard(
    BuildContext context, {
    required String title,
    required String duration,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: () => _showMeditationPlayer(title, duration),
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.8),
                  color,
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 40),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  duration,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreathingExercises(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Breathing Exercises',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildBreathingTechnique(
              '4-7-8 Breathing',
              'Inhale for 4, hold for 7, exhale for 8',
              Icons.air,
              AppColors.oceanBlue,
            ),
            const Divider(),
            _buildBreathingTechnique(
              'Box Breathing',
              'Equal counts of inhale, hold, exhale, and pause',
              Icons.crop_square,
              AppColors.turquoise,
            ),
            const Divider(),
            _buildBreathingTechnique(
              'Deep Belly Breathing',
              'Focus on expanding your diaphragm',
              Icons.circle_outlined,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreathingTechnique(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
      trailing: ElevatedButton(
        onPressed: () => _startBreathingExercise(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text('Start'),
      ),
    );
  }

  Widget _buildStressManagement(BuildContext context) {
    final techniques = [
      {
        'title': 'Progressive Muscle Relaxation',
        'icon': Icons.accessibility_new,
        'color': AppColors.oceanBlue,
      },
      {
        'title': 'Grounding Techniques',
        'icon': Icons.nature_people,
        'color': AppColors.turquoise,
      },
      {
        'title': 'Mindful Walking',
        'icon': Icons.directions_walk,
        'color': Colors.purple,
      },
      {
        'title': 'Journaling Prompts',
        'icon': Icons.edit_note,
        'color': Colors.indigo,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stress Management',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: techniques.length,
          itemBuilder: (context, index) {
            final technique = techniques[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  // Show technique details
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        (technique['color'] as Color).withOpacity(0.8),
                        technique['color'] as Color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        technique['icon'] as IconData,
                        size: 32,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          technique['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSleepHygiene(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.withOpacity(0.8),
              Colors.indigo,
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.nightlight_round,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Sleep Hygiene',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSleepTip(
              'Consistent Schedule',
              'Go to bed and wake up at the same time',
              Icons.schedule,
            ),
            const Divider(color: Colors.white24),
            _buildSleepTip(
              'Bedtime Routine',
              'Develop a relaxing pre-sleep routine',
              Icons.nightlight_round,
            ),
            const Divider(color: Colors.white24),
            _buildSleepTip(
              'Screen Time',
              'Avoid screens 1 hour before bed',
              Icons.phone_android,
            ),
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  // Show sleep guide
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('View Full Sleep Guide'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepTip(String title, String description, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        description,
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
    );
  }
}

class _BreathingExerciseSheet extends StatelessWidget {
  final String type;
  final VoidCallback onStart;

  const _BreathingExerciseSheet({
    required this.type,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This exercise will help you focus on your breath and reduce stress. Find a comfortable position and when you\'re ready, tap Start.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.oceanBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Start Exercise',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreathingOverlay extends StatelessWidget {
  final Animation<double> animation;
  final String phase;
  final int count;
  final VoidCallback onClose;

  const _BreathingOverlay({
    required this.animation,
    required this.phase,
    required this.count,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: animation,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.turquoise,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        phase,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Breath count: $count',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeditationPlayerSheet extends StatelessWidget {
  final String title;
  final String duration;

  const _MeditationPlayerSheet({
    required this.title,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  duration,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10),
                      onPressed: () {},
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 32),
                    FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: AppColors.oceanBlue,
                      child: const Icon(Icons.play_arrow),
                    ),
                    const SizedBox(width: 32),
                    IconButton(
                      icon: const Icon(Icons.forward_10),
                      onPressed: () {},
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                LinearProgressIndicator(
                  value: 0,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.oceanBlue),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0:00'),
                    Text('5:00'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 