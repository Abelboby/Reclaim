import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../chat/chat_screen.dart';

class SupportIntroScreen extends StatelessWidget {
  const SupportIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Support Companion'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildHowItHelps(context),
            const SizedBox(height: 24),
            _buildStarterTopics(context),
            const SizedBox(height: 24),
            _buildEmergencySupport(context),
            const SizedBox(height: 24),
            _buildPrivacyNote(context),
            const SizedBox(height: 32),
            _buildStartButton(context),
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
          Icons.psychology,
          size: 48,
          color: AppColors.oceanBlue,
        ),
        const SizedBox(height: 16),
        Text(
          'Your 24/7 Recovery Guide',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.oceanBlue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'A judgment-free space where you can find support, motivation, and guidance on your recovery journey.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildHowItHelps(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How It Helps',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildHelpItem(
              Icons.track_changes,
              'Track Progress',
              'Monitor your recovery journey and celebrate milestones',
            ),
            _buildHelpItem(
              Icons.psychology_outlined,
              'Coping Strategies',
              'Learn and practice effective techniques to manage triggers',
            ),
            _buildHelpItem(
              Icons.emoji_objects,
              'Daily Motivation',
              'Get inspired with personalized encouragement',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.turquoise),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarterTopics(BuildContext context) {
    final topics = [
      'I need help with a craving',
      'Feeling triggered right now',
      'Share my progress',
      'Need motivation',
      'Develop a coping plan',
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Start a Conversation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topics.map((topic) => ActionChip(
                label: Text(topic),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(initialMessage: topic),
                    ),
                  );
                },
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencySupport(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emergency, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Need Immediate Help?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'While I\'m here to support you, please remember that I\'m an AI assistant. If you\'re in crisis:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Implement emergency contact functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone),
                SizedBox(width: 8),
                Text('Contact Emergency Support'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy & Trust',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your conversations are private and confidential. We use industry-standard encryption to protect your data.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.oceanBlue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Start Conversation',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
} 