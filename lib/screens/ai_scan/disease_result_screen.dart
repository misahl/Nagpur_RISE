import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/disease_scan_model.dart';
import '../../core/constants/app_colors.dart';
import '../farm/farm_map_screen.dart';
import '../tasks/assign_task_screen.dart';
import '../reports/reports_screen.dart';

class DiseaseResultScreen extends StatelessWidget {
  final DiseaseScanModel scanResult;

  const DiseaseResultScreen({super.key, required this.scanResult});

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'high':
        return AppColors.diseasedRed;
      case 'medium':
        return AppColors.moderateYellow;
      case 'low':
      default:
        return AppColors.healthyGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor(scanResult.severity);
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(scanResult.timestamp);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Disease Diagnosis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Uploaded Leaf Image
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: scanResult.imageUrl.startsWith('assets/')
                    ? Image.asset(scanResult.imageUrl, fit: BoxFit.cover)
                    : (File(scanResult.imageUrl).existsSync()
                        ? Image.file(File(scanResult.imageUrl), fit: BoxFit.cover)
                        : Image.asset('assets/images/canker_leaf.jpg', fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(height: 16),

            // Main Disease Diagnosis Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: severityColor.withAlpha(100), width: 1.5),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          scanResult.diseaseName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: severityColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: severityColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: severityColor.withAlpha(80)),
                        ),
                        child: Text(
                          '${scanResult.severity.toUpperCase()} SEVERITY',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: severityColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Confidence Meter
                  Row(
                    children: [
                      const Text(
                        'Confidence Score:',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(scanResult.confidence * 100).toInt()}%',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: scanResult.confidence,
                      minHeight: 8,
                      backgroundColor: AppColors.borderSubtle,
                      valueColor: AlwaysStoppedAnimation<Color>(severityColor),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Metadata list
                  _buildMetaRow('Farm', 'Green Valley Orange Farm', Icons.agriculture),
                  const Divider(height: 16),
                  _buildMetaRow('Affected Zone', scanResult.zoneName, Icons.layers_outlined),
                  const Divider(height: 16),
                  _buildMetaRow('Identified Tree', scanResult.treeCode, Icons.park_outlined),
                  const Divider(height: 16),
                  _buildMetaRow('Date of Diagnosis', dateStr, Icons.access_time),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // AI Explanation & Visual Indicators
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.visibility_outlined, color: AppColors.primaryOrange, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Detected Visual Indicators',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...scanResult.visualIndicators.map((indicator) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, size: 16, color: AppColors.primaryOrange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              indicator,
                              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recommended Action Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.greenSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.healthyGreen.withAlpha(80)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.health_and_safety, color: AppColors.healthyGreen, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Agronomic Recommended Action',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scanResult.recommendedAction,
                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Required Action Buttons: SAVE REPORT, MARK FOR INSPECTION, VIEW ON FARM MAP
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Diagnosis report saved to Firestore & Farm History!'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportsScreen()),
                );
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('SAVE REPORT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AssignTaskScreen(
                      initialZone: scanResult.zoneName,
                      initialTitle: 'Inspect ${scanResult.treeCode} (${scanResult.diseaseName})',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.assignment_turned_in_outlined),
              label: const Text('MARK FOR INSPECTION'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FarmMapScreen()),
                );
              },
              icon: const Icon(Icons.map_outlined),
              label: const Text('VIEW ON FARM MAP'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.borderSubtle),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
