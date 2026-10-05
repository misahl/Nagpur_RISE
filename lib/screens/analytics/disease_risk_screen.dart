import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/farm_map_widget.dart';
import '../farm/farm_map_screen.dart';
import '../ai_scan/ai_crop_scan_screen.dart';

class DiseaseRiskScreen extends StatelessWidget {
  const DiseaseRiskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final farm = farmState.currentFarm;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Risk Prediction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Heatmap preview banner
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Orchard Disease Heatmap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FarmMapScreen()));
                  },
                  child: const Text('Full Screen Map', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            FarmMapWidget(
              farm: farm,
              zones: farmState.zones,
              height: 220,
              showHeatmap: true,
            ),
            const SizedBox(height: 16),

            // Zone Risk Breakdown Cards
            const Text(
              'Microclimate & Zone Risk Index',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),

            _buildZoneRiskCard(
              zone: 'Zone A',
              riskScore: 8,
              riskLevel: 'LOW',
              color: AppColors.healthyGreen,
              reasons: [
                'Optimal aeration and low morning dew retention',
                'No historical fungal or bacterial outbreaks in last 12 months',
                'Strong vegetative cuticle density',
              ],
            ),
            const SizedBox(height: 10),

            _buildZoneRiskCard(
              zone: 'Zone B',
              riskScore: 34,
              riskLevel: 'MEDIUM',
              color: AppColors.moderateYellow,
              reasons: [
                'Recent Citrus Canker diagnostic detection on Tree B-042',
                'Low root zone moisture (24%) causing localized stress',
                'Minor leafminer injury creating bacterial entry points',
              ],
            ),
            const SizedBox(height: 10),

            _buildZoneRiskCard(
              zone: 'Zone C',
              riskScore: 72,
              riskLevel: 'HIGH',
              color: AppColors.diseasedRed,
              reasons: [
                'High microclimate humidity (>85%) in lower southern depression',
                'Prior twig blight fungal spores observed',
                'Dense canopy shade reducing ultraviolet solar penetration',
                'Soil compaction causing moisture stagnation',
              ],
            ),
            const SizedBox(height: 20),

            // Preventive action button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AiCropScanScreen()));
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Run Diagnostic AI Scan in High Risk Zone'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneRiskCard({
    required String zone,
    required int riskScore,
    required String riskLevel,
    required Color color,
    required List<String> reasons,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(80), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(zone, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(8)),
                child: Text('$riskScore% $riskLevel', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: riskScore / 100.0,
              minHeight: 6,
              backgroundColor: AppColors.borderSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Contributing Agronomic Factors:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          ...reasons.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 6, color: color),
                    const SizedBox(width: 8),
                    Expanded(child: Text(r, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
