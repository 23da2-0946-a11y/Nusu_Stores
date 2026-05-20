import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  final String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF387B40);
    const Color lightGreen = Color(0xFF8CC18D);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade400],
            stops: const [0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const CustomHeader(title: 'Settings'),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    _buildSettingsSection('Preferences', [
                      _buildSwitchTile(
                        'Push Notifications',
                        'Stay updated with order status',
                        _notificationsEnabled,
                        (val) => setState(() => _notificationsEnabled = val),
                        primaryColor,
                      ),
                      _buildSwitchTile(
                        'Dark Mode',
                        'Reduce eye strain at night',
                        _darkMode,
                        (val) => setState(() => _darkMode = val),
                        primaryColor,
                      ),
                    ], lightGreen),
                    const SizedBox(height: 20),
                    _buildSettingsSection('Account', [
                      _buildListTile('Language', _selectedLanguage, Icons.language, () {
                        // Language selection logic
                      }, primaryColor),
                      _buildListTile('Account Privacy', 'Public', Icons.lock_outline, () {}, primaryColor),
                    ], lightGreen),
                    const SizedBox(height: 20),
                    _buildSettingsSection('App Info', [
                      _buildListTile('Version', '1.0.0', Icons.info_outline, null, primaryColor),
                      _buildListTile('Terms of Service', '', Icons.description_outlined, () {}, primaryColor),
                    ], lightGreen),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children, Color lightGreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'Georgia',
              color: Color(0xFF387B40),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: lightGreen, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged, Color primaryColor) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: primaryColor,
        activeTrackColor: primaryColor.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildListTile(String title, String trailing, IconData icon, VoidCallback? onTap, Color primaryColor) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing.isNotEmpty)
            Text(trailing, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          if (onTap != null) const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
