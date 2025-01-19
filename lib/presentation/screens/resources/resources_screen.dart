import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'news_screen.dart';
import 'mindfulness_screen.dart';
import 'support_groups_screen.dart';
import '../../../core/animations/app_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen>
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
      3,
      (index) => CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.2,
          0.6 + (index * 0.2),
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
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Resources',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.oceanBlue,
                      AppColors.turquoise,
                    ],
                  ),
                ),
                child: AppAnimations.shimmer(
                  child: Icon(
                    Icons.library_books,
                    size: 100,
                    color: Colors.white.withOpacity(0.2),
                  ),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppAnimations.slideUp(
                    animation: _animations[0],
                    child: _buildHeader(),
                  ),
                  // const SizedBox(height: 6),
                  AppAnimations.slideUp(
                    animation: _animations[1],
                    child: _buildResourceCategories(context),
                  ),
                  const SizedBox(height: 32),
                  AppAnimations.slideUp(
                    animation: _animations[2],
                    child: _buildFeaturedContent(context),
                  ),
                ],
              ),
            ),
          ),
        ],
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
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.oceanBlue,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Explore tools and information to support your recovery journey',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            height: 1.5,
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
              AppAnimations.fadeScale(child: const MindfulnessScreen()),
            ),
      },
      {
        'title': 'Recovery News',
        'icon': Icons.article_outlined,
        'color': AppColors.oceanBlue,
        'description': 'Latest articles and research on recovery',
        'onTap': () => Navigator.push(
              context,
              AppAnimations.fadeScale(child: const NewsScreen()),
            ),
      },
      {
        'title': 'Support Groups',
        'icon': Icons.group_outlined,
        'color': Colors.purple,
        'description': 'Find local and online support communities',
        'onTap': () => Navigator.push(
              context,
              AppAnimations.fadeScale(child: const SupportGroupsScreen()),
            ),
      },
      {
        'title': 'Emergency Help',
        'icon': Icons.emergency_outlined,
        'color': Colors.red,
        'description': '24/7 crisis support and hotlines',
        'onTap': () {
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
    return Hero(
      tag: title,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: color.withOpacity(0.1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: color,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 8,
          shadowColor: AppColors.turquoise.withOpacity(0.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  AppColors.turquoise.withOpacity(0.1),
                ],
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.turquoise.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tips_and_updates,
                  color: AppColors.turquoise,
                  size: 28,
                ),
              ),
              title: const Text(
                'Daily Recovery Tip',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Practice mindfulness for 5 minutes today',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.emergency, color: Colors.red.shade600, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Emergency Support',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Immediate help is available 24/7',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildEmergencyContact(
            'National Crisis Hotline',
            '1-800-662-4357',
            Icons.phone,
          ),
          const SizedBox(height: 16),
          _buildEmergencyContact(
            'Suicide Prevention Lifeline',
            '988',
            Icons.phone,
          ),
          const SizedBox(height: 16),
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
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyContact(String title, String contact, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final Uri phoneUri = Uri(
            scheme: 'tel',
            path: contact.replaceAll('-', ''),
          );
          if (await canLaunchUrl(phoneUri)) {
            await launchUrl(phoneUri);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: Colors.red.shade600),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
                    Text(
                      contact,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
