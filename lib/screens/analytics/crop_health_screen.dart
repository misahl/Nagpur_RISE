import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/health_indicator.dart';

class CropHealthScreen extends StatelessWidget {
  const CropHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final farm = farmState.currentFarm;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Health Index'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Circular Health Indicator Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
              ),
              child: Column(
                children: [
                  HealthIndicator(
                    score: farm.healthScore,
                    size: 140,
                    strokeWidth: 12,
                    title: 'Overall Orchard Health',
                    subtitle: farm.healthScore >= 80 ? 'Vigorous Canopy' : 'Attention Required',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Synthesized using multispectral drone imagery, IoT soil tensiometers, microclimate sensors, and AI disease scans.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 5 Key Health Indicators Breakdown
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
                  const Text(
                    'Component Agronomic Health Scores',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildComponentRow('Leaf Health', 92.0, AppColors.healthyGreen, 'Chlorophyll saturation and stomatal conductance are high.'),
                  const Divider(height: 24),
                  _buildComponentRow('Soil Health', 81.0, Colors.teal, 'Balanced NPK ratio with optimal organic carbon and aeration.'),
                  const Divider(height: 24),
                  _buildComponentRow('Water Status', 76.0, AppColors.blueAccent, 'Adequate moisture in Zones A, C, D; Zone B deficit flagged.'),
                  const Divider(height: 24),
                  _buildComponentRow('Disease Risk', 12.0, AppColors.diseasedRed, 'Isolated Citrus Canker in Zone B under containment.', isInverse: true),
                  const Divider(height: 24),
                  _buildComponentRow('Pest Risk', 8.0, AppColors.moderateYellow, 'Citrus leafminer presence below economic injury threshold.', isInverse: true),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Zone-by-Zone Breakdown
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
                  const Text(
                    'Zone-by-Zone Health Comparison',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...farmState.zones.map((z) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 5, backgroundColor: z.displayColor),
                          const SizedBox(width: 10),
                          SizedBox(width: 70, child: Text(z.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: z.healthScore / 100.0,
                                minHeight: 8,
                                backgroundColor: AppColors.borderSubtle,
                                valueColor: AlwaysStoppedAnimation<Color>(z.displayColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('${z.healthScore.toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: z.displayColor)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentRow(String title, double score, Color color, String explanation, {bool isInverse = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('${score.toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100.0,
            minHeight: 8,
            backgroundColor: AppColors.borderSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(explanation, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
