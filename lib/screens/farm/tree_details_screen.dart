import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tree_model.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/health_indicator.dart';
import '../ai_scan/ai_crop_scan_screen.dart';
import '../tasks/assign_task_screen.dart';

class TreeDetailsScreen extends StatelessWidget {
  final TreeModel tree;

  const TreeDetailsScreen({super.key, required this.tree});

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    // Find current tree state in provider
    final currentTree = farmState.trees.firstWhere((t) => t.id == tree.id, orElse: () => tree);

    Color statusColor;
    if (currentTree.currentStatus == 'Healthy') {
      statusColor = AppColors.healthyGreen;
    } else if (currentTree.currentStatus == 'Needs Inspection') {
      statusColor = AppColors.inspectionOrange;
    } else {
      statusColor = AppColors.diseasedRed;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTree.treeCode),
        actions: [
          IconButton(
            tooltip: 'Assign Inspection',
            icon: const Icon(Icons.assignment_ind_outlined, color: AppColors.primaryOrange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AssignTaskScreen(initialZone: 'Zone B'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tree Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Row(
                children: [
                  HealthIndicator(
                    score: currentTree.healthScore,
                    size: 90,
                    subtitle: currentTree.currentStatus,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentTree.treeCode,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            currentTree.currentStatus.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Age: ${currentTree.ageYears} Years • ${currentTree.variety}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Agronomic Specs
            const Text(
              'Tree Profile & Inspection History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: [
                  _buildRow('Assigned Zone', 'Zone B (Central Plot)', Icons.layers_outlined),
                  const Divider(height: 20),
                  _buildRow('GPS Coordinates', '${currentTree.latitude}, ${currentTree.longitude}', Icons.gps_fixed),
                  const Divider(height: 20),
                  _buildRow('Last Inspection', currentTree.lastInspection, Icons.calendar_today_outlined),
                  const Divider(height: 20),
                  _buildRow('Historical Disease Cases', '${currentTree.diseaseHistoryCount} previous cases', Icons.history),
                  const Divider(height: 20),
                  _buildRow('Drip Line Emitter', 'Emitter B-42 (Flow: 4 L/h)', Icons.water_drop_outlined),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Diagnostic Notes Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.orangeSurface.withAlpha(80),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryOrange.withAlpha(80)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notes, color: AppColors.primaryOrange, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Agronomist & AI Diagnostic Notes',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentTree.notes.isNotEmpty
                        ? currentTree.notes
                        : 'Routine vegetative cycle. Recommended for leaf sample imaging.',
                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // AI Crop Scan Trigger
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AiCropScanScreen()),
                );
              },
              icon: const Icon(Icons.camera_alt),
              label: Text('Run AI Crop Scan on ${currentTree.treeCode}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String val, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryOrange),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const Spacer(),
        Flexible(
          child: Text(
            val,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
