import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _reservationReminders = true;
  bool _locationAccess = true;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD (\$)';

  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Italian'];
  final List<String> _currencies = ['USD (\$)', 'EUR (€)', 'GBP (£)', 'CAD (C\$)'];

  static const primary = Color(0xFF0C1B2A);
  static const accent = Color(0xFFD4AF6A);
  static const borderColor = Color(0xFFE5E5E5);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: borderColor, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20),
                  color: primary,
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Appearance Section
                  _buildSettingsCard(
                    icon: Icons.brightness_6_outlined,
                    title: 'Appearance',
                    subtitle: 'Customize how the app looks and feels',
                    children: [
                      _buildSwitchTile(
                        title: 'Dark Mode',
                        subtitle: 'Switch between light and dark themes',
                        value: _darkMode,
                        onChanged: (value) => setState(() => _darkMode = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Language & Region Section
                  _buildSettingsCard(
                    icon: Icons.language_outlined,
                    title: 'Language & Region',
                    subtitle: 'Set your preferred language and currency',
                    children: [
                      _buildDropdownTile(
                        title: 'Language',
                        value: _selectedLanguage,
                        items: _languages,
                        onChanged: (value) => setState(() => _selectedLanguage = value!),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownTile(
                        title: 'Currency',
                        value: _selectedCurrency,
                        items: _currencies,
                        onChanged: (value) => setState(() => _selectedCurrency = value!),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Notifications Section
                  _buildSettingsCard(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage how you receive notifications',
                    children: [
                      _buildSwitchTile(
                        title: 'Push Notifications',
                        subtitle: 'Receive notifications on your device',
                        value: _pushNotifications,
                        onChanged: (value) => setState(() => _pushNotifications = value),
                      ),
                      const SizedBox(height: 16),
                      _buildSwitchTile(
                        title: 'Email Notifications',
                        subtitle: 'Receive updates via email',
                        value: _emailNotifications,
                        onChanged: (value) => setState(() => _emailNotifications = value),
                      ),
                      const SizedBox(height: 16),
                      _buildSwitchTile(
                        title: 'Reservation Reminders',
                        subtitle: 'Get reminded about upcoming reservations',
                        value: _reservationReminders,
                        onChanged: (value) => setState(() => _reservationReminders = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Privacy & Security Section
                  _buildSettingsCard(
                    icon: Icons.security_outlined,
                    title: 'Privacy & Security',
                    subtitle: 'Control your privacy and security settings',
                    children: [
                      _buildSwitchTile(
                        title: 'Location Access',
                        subtitle: 'Allow app to access your location for nearby restaurants',
                        value: _locationAccess,
                        onChanged: (value) => setState(() => _locationAccess = value),
                      ),
                      const SizedBox(height: 16),
                      _buildActionButton(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        onTap: () {
                          // TODO: Navigate to privacy policy
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildActionButton(
                        icon: Icons.description_outlined,
                        title: 'Terms of Service',
                        onTap: () {
                          // TODO: Navigate to terms of service
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // About Section
                  _buildSettingsCard(
                    icon: Icons.phone_android_outlined,
                    title: 'About',
                    subtitle: null,
                    children: [
                      _buildInfoRow('Version', '1.0.0'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Build', '2024.1.1'),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(icon, size: 20, color: primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
            const SizedBox(height: 16),
            
            // Content
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: accent,
          activeTrackColor: accent.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor.withOpacity(0.5)),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: accent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: accent),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: accent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: primary,
          ),
        ),
      ],
    );
  }
}
