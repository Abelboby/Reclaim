import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SupportGroupsScreen extends StatelessWidget {
  const SupportGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Groups'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildLocalGroups(context),
            const SizedBox(height: 24),
            _buildOnlineCommunities(context),
            const SizedBox(height: 24),
            _buildFamilySupport(context),
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
          Icons.group_outlined,
          size: 48,
          color: AppColors.oceanBlue,
        ),
        const SizedBox(height: 16),
        Text(
          'Find Your Support Network',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.oceanBlue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Connect with others on the recovery journey',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLocalGroups(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Local Support Groups',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your location',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Implement location search
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.oceanBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Find Nearby Groups'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOnlineCommunities(BuildContext context) {
    final communities = [
      {
        'name': 'Recovery Chat Room',
        'members': '1.2k online',
        'description': '24/7 peer support and discussion',
        'icon': Icons.chat_bubble_outline,
      },
      {
        'name': 'Daily Check-in Group',
        'members': '3.5k members',
        'description': 'Share your progress and support others',
        'icon': Icons.check_circle_outline,
      },
      {
        'name': 'Newcomers Welcome',
        'members': '850 online',
        'description': 'Get started on your recovery journey',
        'icon': Icons.emoji_people,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Online Communities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...communities.map((community) => Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.turquoise.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                community['icon'] as IconData,
                color: AppColors.turquoise,
              ),
            ),
            title: Text(
              community['name'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(community['members'] as String),
                Text(community['description'] as String),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                // Implement community navigation
              },
            ),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildFamilySupport(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.family_restroom,
                  color: AppColors.oceanBlue,
                ),
                SizedBox(width: 8),
                Text(
                  'Family & Friends Support',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Recovery affects the whole family. Find resources and support groups specifically for loved ones:',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildFamilyResourceButton(
              'Al-Anon Family Groups',
              'Support for families of alcoholics',
              Icons.people_outline,
            ),
            const SizedBox(height: 8),
            _buildFamilyResourceButton(
              'Nar-Anon Family Groups',
              'Support for families of addicts',
              Icons.support,
            ),
            const SizedBox(height: 8),
            _buildFamilyResourceButton(
              'Family Counseling',
              'Find family therapists specializing in addiction',
              Icons.psychology,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyResourceButton(String title, String subtitle, IconData icon) {
    return OutlinedButton(
      onPressed: () {
        // Implement resource navigation
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.oceanBlue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
} 