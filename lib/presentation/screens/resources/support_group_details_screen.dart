import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/support_group.dart';

class SupportGroupDetailsScreen extends StatelessWidget {
  final SupportGroup group;

  const SupportGroupDetailsScreen({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildDetails(context),
            if (!group.isOnline) _buildLocation(context),
            _buildMeetingSchedule(context),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.oceanBlue.withOpacity(0.1),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          Icon(
            group.isOnline ? Icons.computer : Icons.location_on,
            size: 64,
            color: AppColors.oceanBlue,
          ),
          const SizedBox(height: 16),
          Text(
            group.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            group.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            Icons.people_outline,
            '${group.memberCount} members',
          ),
          if (group.rating > 0) ...[
            const SizedBox(height: 8),
            _buildDetailRow(
              Icons.star,
              '${group.rating} rating',
              color: Colors.amber,
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: group.tags.map((tag) => Chip(
              label: Text(tag),
              backgroundColor: AppColors.turquoise.withOpacity(0.1),
              labelStyle: TextStyle(color: AppColors.turquoise),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(
                Icons.location_on,
                color: AppColors.oceanBlue,
              ),
              title: Text(group.address),
              trailing: IconButton(
                icon: const Icon(Icons.directions),
                onPressed: () => _openMaps(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingSchedule(BuildContext context) {
    if (group.meetingSchedule.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meeting Schedule',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(
                Icons.calendar_today,
                color: AppColors.oceanBlue,
              ),
              title: Text(group.meetingSchedule),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              // TODO: Implement join group functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.oceanBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Join Group'),
          ),
          const SizedBox(height: 8),
          if (!group.isOnline)
            OutlinedButton(
              onPressed: () => _openMaps(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Get Directions'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color ?? Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Future<void> _openMaps() async {
    if (group.latitude == 0 && group.longitude == 0) {
      final encodedAddress = Uri.encodeComponent(group.address);
      final url = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
      if (await canLaunch(url)) {
        await launch(url);
      }
    } else {
      final url = 'https://www.google.com/maps/search/?api=1&query=${group.latitude},${group.longitude}';
      if (await canLaunch(url)) {
        await launch(url);
      }
    }
  }
} 