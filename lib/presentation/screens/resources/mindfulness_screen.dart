import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MindfulnessScreen extends StatelessWidget {
  const MindfulnessScreen({super.key});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.self_improvement,
          size: 48,
          color: AppColors.oceanBlue,
        ),
        const SizedBox(height: 16),
        Text(
          'Mindfulness Tools',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.oceanBlue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Practice these exercises to manage stress, anxiety, and cravings',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
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
        _buildMeditationCard(
          context,
          title: 'Craving Management',
          duration: '5 minutes',
          icon: Icons.waves,
        ),
        const SizedBox(height: 12),
        _buildMeditationCard(
          context,
          title: 'Stress Relief',
          duration: '10 minutes',
          icon: Icons.spa,
        ),
        const SizedBox(height: 12),
        _buildMeditationCard(
          context,
          title: 'Body Scan',
          duration: '15 minutes',
          icon: Icons.accessibility_new,
        ),
      ],
    );
  }

  Widget _buildMeditationCard(
    BuildContext context, {
    required String title,
    required String duration,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.turquoise.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.turquoise),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(duration),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_filled),
          color: AppColors.oceanBlue,
          onPressed: () {
            // Implement meditation playback
          },
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
            ),
            const Divider(),
            _buildBreathingTechnique(
              'Box Breathing',
              'Equal counts of inhale, hold, exhale, and pause',
              Icons.crop_square,
            ),
            const Divider(),
            _buildBreathingTechnique(
              'Deep Belly Breathing',
              'Focus on expanding your diaphragm',
              Icons.circle_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreathingTechnique(String title, String description, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.turquoise),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
      trailing: IconButton(
        icon: const Icon(Icons.play_circle_outline),
        onPressed: () {
          // Implement breathing exercise
        },
      ),
    );
  }

  Widget _buildStressManagement(BuildContext context) {
    final techniques = [
      {
        'title': 'Progressive Muscle Relaxation',
        'icon': Icons.accessibility_new,
      },
      {
        'title': 'Grounding Techniques',
        'icon': Icons.nature_people,
      },
      {
        'title': 'Mindful Walking',
        'icon': Icons.directions_walk,
      },
      {
        'title': 'Journaling Prompts',
        'icon': Icons.edit_note,
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
            childAspectRatio: 1.5,
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
                  // Implement technique details
                },
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      technique['icon'] as IconData,
                      size: 32,
                      color: AppColors.oceanBlue,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      technique['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sleep Hygiene',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSleepTip(
              'Consistent Schedule',
              'Go to bed and wake up at the same time',
              Icons.schedule,
            ),
            const Divider(),
            _buildSleepTip(
              'Bedtime Routine',
              'Develop a relaxing pre-sleep routine',
              Icons.nightlight_round,
            ),
            const Divider(),
            _buildSleepTip(
              'Screen Time',
              'Avoid screens 1 hour before bed',
              Icons.phone_android,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Implement sleep guide
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('View Full Sleep Guide'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepTip(String title, String description, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.turquoise),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
    );
  }
} 