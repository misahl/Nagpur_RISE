import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/farm_state_provider.dart';
import '../../widgets/alert_card.dart';
import '../../core/constants/app_colors.dart';
import '../ai_scan/ai_crop_scan_screen.dart';
import '../irrigation/smart_irrigation_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Disease',
    'Water',
    'Weather',
    'Pest',
    'Drone',
  ];

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final alerts = farmState.alerts.where((a) {
      if (_selectedCategory == 'All') return true;
      return a.type.toLowerCase() == _selectedCategory.toLowerCase();
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Orchard Alerts'),
      ),
      body: Column(
        children: [
          // Category selector chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primaryOrange.withAlpha(35),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primaryOrange : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Alerts list
          Expanded(
            child: alerts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const Text('No alerts found in this category', style: TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      return AlertCard(
                        alert: alert,
                        onTap: () {
                          farmState.markAlertRead(alert.id);
                          if (alert.type == 'Disease') {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const AiCropScanScreen()));
                          } else if (alert.type == 'Water') {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const SmartIrrigationScreen()));
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
