import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class HealthIndicator extends StatelessWidget {
  final double score; // 0 to 100
  final double size;
  final double strokeWidth;
  final String title;
  final String? subtitle;
  final bool showPercent;

  const HealthIndicator({
    super.key,
    required this.score,
    this.size = 110,
    this.strokeWidth = 9,
    this.title = 'Farm Health',
    this.subtitle,
    this.showPercent = true,
  });

  Color _getColor(double val) {
    if (val >= 80) return AppColors.healthyGreen;
    if (val >= 65) return AppColors.moderateYellow;
    if (val >= 45) return AppColors.inspectionOrange;
    return AppColors.diseasedRed;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(score);
    final percent = (score / 100.0).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: percent,
                strokeWidth: strokeWidth,
                strokeCap: StrokeCap.round,
                backgroundColor: AppColors.borderSubtle,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${score.toInt()}%',
                      style: TextStyle(
                        fontSize: size * 0.26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: size * 0.11,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (title.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
