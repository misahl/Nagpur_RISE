import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';

class SmartIrrigationScreen extends StatelessWidget {
  const SmartIrrigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final irrigation = farmState.irrigationService;
    final isRainComing = farmState.weather.rainProbability > 50;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Precision Irrigation'),
        actions: [
          if (irrigation.isAnyPumpActive)
            TextButton.icon(
              onPressed: () => irrigation.stopAll(),
              icon: const Icon(Icons.stop_circle, color: AppColors.diseasedRed),
              label: const Text('STOP ALL', style: TextStyle(color: AppColors.diseasedRed, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: AnimatedBuilder(
        animation: irrigation,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // AI Advisory Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isRainComing ? AppColors.blueSurface : AppColors.greenSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isRainComing ? AppColors.blueAccent : AppColors.healthyGreen.withAlpha(80),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isRainComing ? Icons.thunderstorm_outlined : Icons.psychology_outlined,
                        color: isRainComing ? AppColors.blueAccent : AppColors.primaryGreen,
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isRainComing ? 'Weather Alert Advisory' : 'AI Drip Optimization',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isRainComing ? AppColors.blueAccent : AppColors.greenDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              irrigation.getAiRecommendation(isRainComing),
                              style: const TextStyle(fontSize: 13, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Water Metering Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem('Total Water Used', '${irrigation.cumulativeLitersUsed.toInt()} L', Icons.water),
                      Container(width: 1, height: 36, color: AppColors.borderSubtle),
                      _buildSummaryItem('Pump State', irrigation.isAnyPumpActive ? 'PUMP ACTIVE' : 'PUMP OFF', Icons.power_settings_new,
                          color: irrigation.isAnyPumpActive ? AppColors.healthyGreen : AppColors.textMuted),
                      Container(width: 1, height: 36, color: AppColors.borderSubtle),
                      _buildSummaryItem('Flow Rate', '24.5 L/min', Icons.speed),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Zone Moisture & Valve Status Cards
                const Text(
                  'Orchard Zones Irrigation Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),

                ...irrigation.zoneStates.map((zState) {
                  Color statusColor;
                  if (zState.isPumpActive) {
                    statusColor = AppColors.blueAccent;
                  } else if (zState.soilMoisture < 35.0) {
                    statusColor = AppColors.diseasedRed;
                  } else if (zState.soilMoisture < 50.0) {
                    statusColor = AppColors.moderateYellow;
                  } else {
                    statusColor = AppColors.healthyGreen;
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 6,
                                    backgroundColor: statusColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    zState.zoneName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withAlpha(20),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  zState.isPumpActive ? 'IRRIGATING (PUMP ON)' : zState.status.toUpperCase(),
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Moisture bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Soil Moisture:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              Text(
                                '${zState.soilMoisture.toStringAsFixed(1)}%',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: statusColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: (zState.soilMoisture / 100.0).clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor: AppColors.borderSubtle,
                              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Water applied to date: ${zState.totalWaterUsedLiters.toInt()} Liters',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 12),

                          // Valve control buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: zState.isPumpActive
                                      ? () => irrigation.stopIrrigation(zState.zoneId)
                                      : () => irrigation.startIrrigation(zState.zoneId),
                                  icon: Icon(zState.isPumpActive ? Icons.stop : Icons.play_arrow),
                                  label: Text(zState.isPumpActive ? 'STOP PUMP' : 'START IRRIGATION'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: zState.isPumpActive ? AppColors.diseasedRed : AppColors.primaryGreen,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Scheduled automated drip cycle for ${zState.zoneName} (6:00 PM)')),
                                  );
                                },
                                icon: const Icon(Icons.schedule, size: 18),
                                label: const Text('SCHEDULE'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color ?? AppColors.primaryOrange),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color ?? AppColors.textPrimary)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}
