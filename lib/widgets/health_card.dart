import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'health_indicator.dart';

class HealthCard extends StatelessWidget {
  final double overallHealth;
  final double diseaseRisk;
  final double pestRisk;
  final double soilMoisture;
  final VoidCallback? onTap;

  const HealthCard({
    super.key,
    required this.overallHealth,
    required this.diseaseRisk,
    required this.pestRisk,
    required this.soilMoisture,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.greenSurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.eco_rounded, color: AppColors.primaryGreen, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Crop Health Score',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Real-time AI & Sensor Index',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  HealthIndicator(
                    score: overallHealth,
                    subtitle: overallHealth >= 80 ? 'Vigorous' : 'Needs Care',
                    title: '',
                    size: 96,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        _buildSubMetricRow('Disease Risk', '${diseaseRisk.toInt()}%', diseaseRisk > 15 ? AppColors.diseasedRed : AppColors.primaryOrange),
                        const SizedBox(height: 10),
                        _buildSubMetricRow('Pest Risk', '${pestRisk.toInt()}%', pestRisk > 10 ? AppColors.moderateYellow : AppColors.healthyGreen),
                        const SizedBox(height: 10),
                        _buildSubMetricRow('Soil Moisture', '${soilMoisture.toInt()}%', soilMoisture < 35 ? AppColors.diseasedRed : AppColors.blueAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubMetricRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
