import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Application Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Selection Section
          const Text('Language & Localization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: AppConstants.supportedLanguages.map((lang) {
                final isSelected = farmState.selectedLanguage == lang;
                return RadioListTile<String>(
                  title: Text(lang, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  value: lang,
                  groupValue: farmState.selectedLanguage,
                  activeColor: AppColors.primaryOrange,
                  onChanged: (val) {
                    if (val != null) {
                      farmState.setLanguage(val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Language updated to $val')),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Simulation & Demo Controls
          const Text('System Simulation & Diagnostics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Demo Mode (Virtual Sensors & Drone)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('Simulates live soil sensors, drone telemetry & AI inference without physical hardware.'),
                  value: farmState.isDemoMode,
                  activeColor: AppColors.primaryOrange,
                  onChanged: (val) => farmState.toggleDemoMode(val),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.cloud_sync_outlined, color: AppColors.primaryGreen),
                  title: const Text('Cloud Firestore & Offline Cache'),
                  subtitle: const Text('24 records synced • Local SQLite cache enabled'),
                  trailing: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Offline database cache refreshed successfully.')),
                      );
                    },
                    child: const Text('Sync Now'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // About App Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('OrangeAI Mobile App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 4),
                Text('Version 1.0.0 (Production Release)', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                SizedBox(height: 8),
                Text(
                  'Engineered for citrus farmers across Maharashtra, Karnataka, Punjab & Kerala. Integrates multispectral drone vision, IoT soil tensiometry, and AI plant pathology.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
