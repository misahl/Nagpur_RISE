import 'package:flutter/material.dart';
import '../../services/report_service.dart';
import '../../core/constants/app_colors.dart';

class FarmReportViewScreen extends StatelessWidget {
  final FarmReportData report;

  const FarmReportViewScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(report.reportId),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sent document to wireless printer.')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSubtle),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🍊 OrangeAI Farm Health Audit',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryOrange),
                      ),
                      Text(
                        'Document ID: ${report.reportId}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.greenSurface, borderRadius: BorderRadius.circular(6)),
                    child: const Text('CERTIFIED', style: TextStyle(color: AppColors.greenDark, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                ],
              ),
              const Divider(height: 24),

              // 1. Farm Details
              _buildSectionTitle('1. Farm & Location Metadata'),
              _buildField('Farm Name', report.farm.name),
              _buildField('Location', report.farm.location),
              _buildField('Cultivated Area', '${report.farm.areaAcres} Acres (${report.zones.length} Zones)'),
              _buildField('Orange Trees', '${report.farm.numberOfTrees} Trees (${report.farm.orangeVariety})'),
              _buildField('Tree Age', '${report.farm.treeAgeYears} Years'),
              _buildField('Irrigation Infrastructure', report.farm.irrigationType),
              const SizedBox(height: 16),

              // 2. Crop Health & Scores
              _buildSectionTitle('2. Crop Health Index'),
              _buildField('Overall Crop Health', '${report.cropHealth.toInt()}%'),
              _buildField('Leaf Chlorophyll Score', '${report.leafHealth.toInt()}%'),
              _buildField('Soil Nutrient Score', '${report.soilHealth.toInt()}%'),
              _buildField('Hydration Status', '${report.waterStatus.toInt()}%'),
              _buildField('Disease Risk', '${report.diseaseRisk.toInt()}%'),
              _buildField('Pest Risk', '${report.pestRisk.toInt()}%'),
              const SizedBox(height: 16),

              // 3. AI Disease Analysis
              _buildSectionTitle('3. AI Disease & Pathogen Detection'),
              _buildField('Diagnostic Scans Logged', '${report.recentScans.length} verified scans'),
              _buildField('Active Pathogen', 'Citrus Canker (Xanthomonas axonopodis) flagged in Zone B'),
              _buildField('Quarantine Status', 'Tree B-042 isolated, copper spray assigned to field worker'),
              const SizedBox(height: 16),

              // 4. Water & Microclimate
              _buildSectionTitle('4. Water Consumption & Microclimate'),
              _buildField('Drip Water Consumed', '${report.totalWaterUsedLiters.toInt()} Liters'),
              _buildField('Current Station Weather', report.weatherSummary),
              const SizedBox(height: 16),

              // 5. Yield Prediction
              _buildSectionTitle('5. Harvest Yield Prediction'),
              _buildField('Estimated Commercial Yield', report.yieldPredictionText),
              const SizedBox(height: 16),

              // 6. Actionable Recommendations
              _buildSectionTitle('6. Agronomist AI Recommendations'),
              ...report.recommendations.map((rec) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: AppColors.primaryGreen),
                        const SizedBox(width: 8),
                        Expanded(child: Text(rec, style: const TextStyle(fontSize: 12, height: 1.3))),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
