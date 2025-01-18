import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'news_screen.dart';
import 'mindfulness_screen.dart';
import 'support_groups_screen.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildResourceCategories(context),
            const SizedBox(height: 24),
            _buildFeaturedContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recovery Resources',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.oceanBlue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Explore tools and information to support your recovery journey',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildResourceCategories(BuildContext context) {
    final categories = [
      {
        'title': 'Mindfulness & Coping',
        'icon': Icons.self_improvement,
        'color': AppColors.turquoise,
        'description': 'Meditation, breathing exercises, and stress management',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MindfulnessScreen()),
        ),
      },
      {
        'title': 'Recovery News',
        'icon': Icons.article_outlined,
        'color': AppColors.oceanBlue,
        'description': 'Latest articles and research on recovery',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewsScreen()),
        ),
      },
      {
        'title': 'Support Groups',
        'icon': Icons.group_outlined,
        'color': Colors.purple,
        'description': 'Find local and online support communities',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SupportGroupsScreen()),
        ),
      },
      {
        'title': 'Emergency Help',
        'icon': Icons.emergency_outlined,
        'color': Colors.red,
        'description': '24/7 crisis support and hotlines',
        'onTap': () {
          // Show emergency contacts dialog
          showDialog(
            context: context,
            builder: (context) => _buildEmergencyDialog(context),
          );
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(
          context,
          title: category['title'] as String,
          icon: category['icon'] as IconData,
          color: category['color'] as Color,
          description: category['description'] as String,
          onTap: category['onTap'] as VoidCallback,
        );
      },
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Content',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Card(
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
              child: const Icon(
                Icons.tips_and_updates,
                color: AppColors.turquoise,
              ),
            ),
            title: const Text(
              'Daily Recovery Tip',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Practice mindfulness for 5 minutes today',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyDialog(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.emergency, color: Colors.red.shade600),
          const SizedBox(width: 8),
          const Text('Emergency Support'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmergencyContact(
            'National Crisis Hotline',
            '1-800-662-4357',
            Icons.phone,
          ),
          const Divider(),
          _buildEmergencyContact(
            'Suicide Prevention Lifeline',
            '988',
            Icons.phone,
          ),
          const Divider(),
          _buildEmergencyContact(
            'Local Emergency',
            '911',
            Icons.emergency,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildEmergencyContact(String title, String contact, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.red.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  contact,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    decoration: TextDecoration.underline,
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