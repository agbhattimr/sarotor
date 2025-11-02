import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

final adminSettingsProvider = StateNotifierProvider<AdminSettingsNotifier, AdminSettings>((ref) {
  return AdminSettingsNotifier();
});

class AdminSettings {
  bool emailNotifications;
  bool pushNotifications;
  bool orderAlerts;
  bool userRegistrationAlerts;
  String systemName;
  String contactEmail;

  AdminSettings({
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.orderAlerts = true,
    this.userRegistrationAlerts = false,
    this.systemName = 'Sartor Order Management',
    this.contactEmail = 'admin@sartor.com',
  });

  AdminSettings copyWith({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? orderAlerts,
    bool? userRegistrationAlerts,
    String? systemName,
    String? contactEmail,
  }) {
    return AdminSettings(
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      orderAlerts: orderAlerts ?? this.orderAlerts,
      userRegistrationAlerts: userRegistrationAlerts ?? this.userRegistrationAlerts,
      systemName: systemName ?? this.systemName,
      contactEmail: contactEmail ?? this.contactEmail,
    );
  }
}

class AdminSettingsNotifier extends StateNotifier<AdminSettings> {
  AdminSettingsNotifier() : super(AdminSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = AdminSettings(
      emailNotifications: prefs.getBool('email_notifications') ?? true,
      pushNotifications: prefs.getBool('push_notifications') ?? true,
      orderAlerts: prefs.getBool('order_alerts') ?? true,
      userRegistrationAlerts: prefs.getBool('user_registration_alerts') ?? false,
      systemName: prefs.getString('system_name') ?? 'Sartor Order Management',
      contactEmail: prefs.getString('contact_email') ?? 'admin@sartor.com',
    );
  }

  Future<void> updateSettings(AdminSettings newSettings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('email_notifications', newSettings.emailNotifications);
    await prefs.setBool('push_notifications', newSettings.pushNotifications);
    await prefs.setBool('order_alerts', newSettings.orderAlerts);
    await prefs.setBool('user_registration_alerts', newSettings.userRegistrationAlerts);
    await prefs.setString('system_name', newSettings.systemName);
    await prefs.setString('contact_email', newSettings.contactEmail);

    state = newSettings;
  }
}

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(adminSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveSettings(context, ref, settings),
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobileBody: _buildMobileSettings(context, ref, settings),
        tabletBody: _buildTabletSettings(context, ref, settings),
      ),
    );
  }

  Widget _buildMobileSettings(BuildContext context, WidgetRef ref, AdminSettings settings) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Notifications'),
        _buildSwitchSetting(
          context,
          'Email Notifications',
          'Receive email alerts for important events',
          settings.emailNotifications,
          (value) => _updateSetting(ref, settings.copyWith(emailNotifications: value)),
        ),
        _buildSwitchSetting(
          context,
          'Push Notifications',
          'Receive push notifications on device',
          settings.pushNotifications,
          (value) => _updateSetting(ref, settings.copyWith(pushNotifications: value)),
        ),
        _buildSwitchSetting(
          context,
          'Order Alerts',
          'Get notified of new orders and status changes',
          settings.orderAlerts,
          (value) => _updateSetting(ref, settings.copyWith(orderAlerts: value)),
        ),
        _buildSwitchSetting(
          context,
          'User Registration Alerts',
          'Get notified when new users register',
          settings.userRegistrationAlerts,
          (value) => _updateSetting(ref, settings.copyWith(userRegistrationAlerts: value)),
        ),

        const SizedBox(height: 24),
        _buildSectionHeader('System Configuration'),
        _buildTextSetting(
          context,
          'System Name',
          'Display name for the application',
          settings.systemName,
          (value) => _updateSetting(ref, settings.copyWith(systemName: value)),
        ),
        _buildTextSetting(
          context,
          'Contact Email',
          'Email for system notifications and contact',
          settings.contactEmail,
          (value) => _updateSetting(ref, settings.copyWith(contactEmail: value)),
        ),

        const SizedBox(height: 24),
        _buildSectionHeader('System Information'),
        _buildInfoCard('Database Status', 'Connected'),
        _buildInfoCard('Version', '1.0.0'),
        _buildInfoCard('Last Backup', '2025-10-31 16:00'),

        const SizedBox(height: 24),
        _buildActionButtons(context, ref),
      ],
    );
  }

  Widget _buildTabletSettings(BuildContext context, WidgetRef ref, AdminSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Notifications'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildSwitchSetting(
                              context,
                              'Email Notifications',
                              'Receive email alerts for important events',
                              settings.emailNotifications,
                              (value) => _updateSetting(ref, settings.copyWith(emailNotifications: value)),
                            ),
                            _buildSwitchSetting(
                              context,
                              'Push Notifications',
                              'Receive push notifications on device',
                              settings.pushNotifications,
                              (value) => _updateSetting(ref, settings.copyWith(pushNotifications: value)),
                            ),
                            _buildSwitchSetting(
                              context,
                              'Order Alerts',
                              'Get notified of new orders and status changes',
                              settings.orderAlerts,
                              (value) => _updateSetting(ref, settings.copyWith(orderAlerts: value)),
                            ),
                            _buildSwitchSetting(
                              context,
                              'User Registration Alerts',
                              'Get notified when new users register',
                              settings.userRegistrationAlerts,
                              (value) => _updateSetting(ref, settings.copyWith(userRegistrationAlerts: value)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('System Configuration'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildTextSetting(
                              context,
                              'System Name',
                              'Display name for the application',
                              settings.systemName,
                              (value) => _updateSetting(ref, settings.copyWith(systemName: value)),
                            ),
                            _buildTextSetting(
                              context,
                              'Contact Email',
                              'Email for system notifications and contact',
                              settings.contactEmail,
                              (value) => _updateSetting(ref, settings.copyWith(contactEmail: value)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader('System Information'),
                    _buildInfoCard('Database Status', 'Connected'),
                    _buildInfoCard('Version', '1.0.0'),
                    _buildInfoCard('Last Backup', '2025-10-31 16:00'),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildActionButtons(context, ref),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSwitchSetting(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextSetting(
    BuildContext context,
    String title,
    String subtitle,
    String value,
    ValueChanged<String> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: SizedBox(
        width: 200,
        child: TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          decoration: const InputDecoration(isDense: true),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(value, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () => _saveSettings(context, ref, ref.read(adminSettingsProvider)),
          icon: const Icon(Icons.save),
          label: const Text('Save Changes'),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () => _resetToDefaults(ref),
          icon: const Icon(Icons.restore),
          label: const Text('Reset to Defaults'),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () => _exportSettings(context, ref),
          icon: const Icon(Icons.download),
          label: const Text('Export Settings'),
        ),
      ],
    );
  }

  void _updateSetting(WidgetRef ref, AdminSettings newSettings) {
    ref.read(adminSettingsProvider.notifier).updateSettings(newSettings);
  }

  void _saveSettings(BuildContext context, WidgetRef ref, AdminSettings settings) async {
    await ref.read(adminSettingsProvider.notifier).updateSettings(settings);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  void _resetToDefaults(WidgetRef ref) {
    final defaultSettings = AdminSettings();
    ref.read(adminSettingsProvider.notifier).updateSettings(defaultSettings);
  }

  Future<void> _exportSettings(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(adminSettingsProvider);

    final settingsData = {
      'email_notifications': settings.emailNotifications,
      'push_notifications': settings.pushNotifications,
      'order_alerts': settings.orderAlerts,
      'user_registration_alerts': settings.userRegistrationAlerts,
      'system_name': settings.systemName,
      'contact_email': settings.contactEmail,
    };

    final jsonString = jsonEncode(settingsData);

    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Admin Settings',
        fileName: 'admin_settings_export.json',
        allowedExtensions: ['json'],
      );

      if (!context.mounted) return;

      if (result != null) {
        final file = File(result);
        await file.writeAsString(jsonString);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings exported successfully')),
        );
      } else {
        // User cancelled
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export cancelled')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to export settings')),
      );
    }
  }
}
