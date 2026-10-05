import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';

class FarmHistoryScreen extends StatelessWidget {
  const FarmHistoryScreen({super.key});

  IconData _getEventIcon(String type) {
    switch (type.toLowerCase()) {
      case 'scan':
        return Icons.biotech;
      case 'drone':
        return Icons.flight_takeoff;
      case 'irrigation':
        return Icons.water_drop;
      case 'inspection':
        return Icons.assignment_turned_in;
      case 'harvest':
        return Icons.agriculture;
      default:
        return Icons.history;
    }
  }

  Color _getEventColor(String type) {
    switch (type.toLowerCase()) {
      case 'scan':
        return AppColors.diseasedRed;
      case 'drone':
        return Colors.indigo;
      case 'irrigation':
        return AppColors.blueAccent;
      case 'inspection':
        return AppColors.primaryGreen;
      case 'harvest':
        return AppColors.primaryOrange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final events = farmState.timelineEvents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orchard Activity Timeline'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final color = _getEventColor(event.type);
          final icon = _getEventIcon(event.type);
          final isLast = index == events.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date column
                SizedBox(
                  width: 55,
                  child: Text(
                    event.date,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                  ),
                ),

                // Line and Node icon
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: color.withAlpha(25), shape: BoxShape.circle),
                      child: Icon(icon, color: color, size: 16),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: AppColors.borderSubtle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Event Content Card
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.description,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
