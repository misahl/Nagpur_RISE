import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/zone_model.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';
import 'tree_details_screen.dart';
import '../ai_scan/ai_crop_scan_screen.dart';
import '../irrigation/smart_irrigation_screen.dart';
import '../tasks/assign_task_screen.dart';

class ZoneDetailsScreen extends StatelessWidget {
  final ZoneModel zone;

  const ZoneDetailsScreen({super.key, required this.zone});

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    // Find current updated zone state
    final currentZone = farmState.zones.firstWhere((z) => z.id == zone.id, orElse: () => zone);
    final zoneTrees = farmState.trees.where((t) => t.zoneId == zone.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${currentZone.name} Overview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: currentZone.displayColor.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: currentZone.displayColor.withAlpha(80), width: 1.5),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: currentZone.displayColor,
                    child: const Icon(Icons.park, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              currentZone.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: currentZone.displayColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                currentZone.statusLabel,
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentZone.description,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Agronomic Metrics Cards
            Row(
              children: [
                _buildMetricTile('Health Score', '${currentZone.healthScore.toInt()}%', Icons.health_and_safety, currentZone.displayColor),
                const SizedBox(width: 10),
                _buildMetricTile('Soil Moisture', '${currentZone.soilMoisture.toInt()}%', Icons.water_drop, currentZone.soilMoisture < 35 ? AppColors.diseasedRed : AppColors.blueAccent),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildMetricTile('Trees in Zone', '${currentZone.numberOfTrees}', Icons.nature, AppColors.primaryGreen),
                const SizedBox(width: 10),
                _buildMetricTile('Disease Cases', '${currentZone.diseaseCases}', Icons.coronavirus, currentZone.diseaseCases > 0 ? AppColors.diseasedRed : AppColors.primaryGreen),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Actions in Zone
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AiCropScanScreen()),
                      );
                    },
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: const Text('Scan Tree in Zone'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SmartIrrigationScreen()),
                      );
                    },
                    icon: const Icon(Icons.water_drop, size: 18),
                    label: const Text('Irrigate Zone'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Registered Trees in Zone
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monitored Trees in this Zone',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AssignTaskScreen(initialZone: currentZone.name)),
                    );
                  },
                  child: const Text('Assign Task', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            if (zoneTrees.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No individual trees registered yet. Tap "Add Tree" on Farm Map.'),
              )
            else
              ...zoneTrees.map((tree) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: tree.currentStatus == 'Healthy'
                          ? AppColors.greenSurface
                          : (tree.currentStatus == 'Needs Inspection' ? AppColors.orangeSurface : Colors.red.shade50),
                      child: Icon(
                        Icons.park,
                        color: tree.currentStatus == 'Healthy'
                            ? AppColors.healthyGreen
                            : (tree.currentStatus == 'Needs Inspection' ? AppColors.inspectionOrange : AppColors.diseasedRed),
                      ),
                    ),
                    title: Text(tree.treeCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(
                      '${tree.variety} • Health: ${tree.healthScore.toInt()}% • Cases: ${tree.diseaseHistoryCount}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TreeDetailsScreen(tree: tree)),
                      );
                    },
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String title, String val, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
