import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: isDark ? AppColors.darkTeal : AppColors.oceanBlue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ListView(
            children: [
              const _SectionHeader(title: 'Appearance'),
              _buildThemeSwitcher(context, themeProvider),
              Divider(color: isDark ? Colors.white30 : Colors.black12),
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
              Divider(color: isDark ? Colors.white30 : Colors.black12),
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
                trailing: Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                onTap: () {
                  // Navigate to data usage settings
                },
              ),
              Divider(color: isDark ? Colors.white30 : Colors.black12),
              const _SectionHeader(title: 'About'),
              _buildSettingsTile(
                context: context,
                title: 'Version',
                subtitle: '1.0.0',
              ),
              _buildSettingsTile(
                context: context,
                title: 'Terms of Service',
                trailing: Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                onTap: () {
                  // Navigate to terms of service
                },
              ),
              _buildSettingsTile(
                context: context,
                title: 'Privacy Policy',
                trailing: Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                onTap: () {
                  // Navigate to privacy policy
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeSwitcher(BuildContext context, ThemeProvider themeProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return _buildSettingsTile(
      context: context,
      title: 'Dark Mode',
      subtitle: 'Toggle dark/light theme',
      trailing: Switch(
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          themeProvider.setThemeMode(
            value ? ThemeMode.dark : ThemeMode.light,
          );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null 
          ? Text(
              subtitle,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ) 
          : null,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: isDark ? AppColors.turquoise : AppColors.oceanBlue,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 