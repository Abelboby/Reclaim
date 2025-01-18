import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Appearance'),
          _buildThemeSwitcher(context),
          const Divider(),
          const _SectionHeader(title: 'Notifications'),
          _buildSettingsTile(
            context: context,
            title: 'Push Notifications',
            subtitle: 'Receive notifications about updates',
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // Handle notification toggle
              },
              activeColor: AppColors.turquoise,
            ),
          ),
          const Divider(),
          const _SectionHeader(title: 'Privacy'),
          _buildSettingsTile(
            context: context,
            title: 'Location Services',
            subtitle: 'Allow app to access location',
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // Handle location toggle
              },
              activeColor: AppColors.turquoise,
            ),
          ),
          _buildSettingsTile(
            context: context,
            title: 'Data Usage',
            subtitle: 'Manage how app uses data',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to data usage settings
            },
          ),
          const Divider(),
          const _SectionHeader(title: 'About'),
          _buildSettingsTile(
            context: context,
            title: 'Version',
            subtitle: '1.0.0',
          ),
          _buildSettingsTile(
            context: context,
            title: 'Terms of Service',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to terms of service
            },
          ),
          _buildSettingsTile(
            context: context,
            title: 'Privacy Policy',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to privacy policy
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSwitcher(BuildContext context) {
    return _buildSettingsTile(
      context: context,
      title: 'Dark Mode',
      subtitle: 'Toggle dark/light theme',
      trailing: Switch(
        value: Theme.of(context).brightness == Brightness.dark,
        onChanged: (value) {
          // Handle theme toggle
        },
        activeColor: AppColors.turquoise,
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.oceanBlue,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 