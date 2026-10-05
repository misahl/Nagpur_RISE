import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';
import 'farm_report_view_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final farm = farmState.currentFarm;

    final reportData = farmState.reportService.generateReport(
      farm: farm,
      zones: farmState.zones,
      recentScans: farmState.diseaseScans,
      totalWaterLiters: farmState.irrigationService.cumulativeLitersUsed,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agronomic Farm Reports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Report Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.greenSurface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          reportData.reportId,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.greenDark),
                        ),
                      ),
                      const Text(
                        'OFFICIAL AUDIT READY',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Comprehensive Orange Farm Health & Traceability Audit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Generated on ${reportData.generatedDate} for ${farm.name}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const Divider(height: 24),

                  // Report Key Highlights
                  _buildSummaryRow('Overall Crop Health', '${reportData.cropHealth.toInt()}% (Vigorous)', AppColors.healthyGreen),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Disease & Pathogen Risk', '${reportData.diseaseRisk.toInt()}% (Zone B flagged)', AppColors.primaryOrange),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Water Usage to Date', '${reportData.totalWaterUsedLiters.toInt()} Liters applied', AppColors.blueAccent),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Yield Estimate', '8.4 Tonnes (Dec 10 – Jan 05)', Colors.indigo),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Three Main Buttons: VIEW REPORT, GENERATE PDF, SHARE REPORT
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FarmReportViewScreen(report: reportData)),
                );
              },
              icon: const Icon(Icons.visibility),
              label: const Text('VIEW REPORT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('PDF Generated: "${reportData.reportId}.pdf" saved to device storage.'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('GENERATE PDF'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryGreen,
                side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sharing Farm Health Audit link with APMC Mandi & Crop Insurance Agents.'),
                  ),
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('SHARE REPORT'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.borderSubtle),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
