import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/sensor_reading_model.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';

class IoTSensorsScreen extends StatelessWidget {
  const IoTSensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final farm = farmState.currentFarm;

    return Scaffold(
      appBar: AppBar(
        title: const Text('IoT Sensor Telemetry'),
      ),
      body: StreamBuilder<SensorReadingModel>(
        stream: farmState.sensorService.getSensorStream(farm.id, 'zone_b'),
        initialData: farmState.sensorService.getLatestReading(farm.id, 'zone_b'),
        builder: (context, snapshot) {
          final data = snapshot.data ?? farmState.sensorService.getLatestReading(farm.id, 'zone_b');
          final timeStr = DateFormat('hh:mm:ss a').format(data.timestamp);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Real-time Gateway Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.router, color: AppColors.primaryGreen, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  'ESP32 Gateway: Node-01',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                SizedBox(width: 8),
                                CircleAvatar(radius: 4, backgroundColor: AppColors.healthyGreen),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Telemetry Active • Last ping at $timeStr',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Top Sensor Gauges Grid
                const Text(
                  'Soil & Atmospheric Parameters',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5,
                  children: [
                    _buildGaugeCard('Soil Moisture', '${data.soilMoisture.toStringAsFixed(1)}%', Icons.water_drop, AppColors.blueAccent, 'Threshold: 45-75%'),
                    _buildGaugeCard('Ambient Temp', '${data.temperature.toStringAsFixed(1)}°C', Icons.thermostat, Colors.deepOrange, 'Optimal: 22-34°C'),
                    _buildGaugeCard('Relative Humidity', '${data.humidity.toStringAsFixed(1)}%', Icons.cloud_queue, Colors.teal, 'Optimal: 60-80%'),
                    _buildGaugeCard('Soil pH', data.soilPh.toStringAsFixed(1), Icons.science, Colors.purple, 'Slightly Acidic (6.0 - 7.0)'),
                  ],
                ),
                const SizedBox(height: 16),

                // N-P-K Soil Nutrients Breakdown
                const Text(
                  'NPK Macronutrients (mg/kg)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
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
                      _buildNpkRow('Nitrogen (N)', data.nitrogen, 100.0, AppColors.primaryGreen, 'Promotes vegetative canopy growth'),
                      const SizedBox(height: 14),
                      _buildNpkRow('Phosphorus (P)', data.phosphorus, 100.0, AppColors.primaryOrange, 'Supports strong citrus root architecture'),
                      const SizedBox(height: 14),
                      _buildNpkRow('Potassium (K)', data.potassium, 100.0, Colors.indigo, 'Increases orange fruit size and sugar brix'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Main Water Tank Level
                const Text(
                  'Irrigation Reservoir Level',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.water, color: AppColors.blueAccent),
                              SizedBox(width: 8),
                              Text('Primary Water Tank', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                          Text('${data.waterTankLevel.toInt()}% Capacity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.blueAccent)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: data.waterTankLevel / 100.0,
                          minHeight: 12,
                          backgroundColor: AppColors.blueSurface,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.blueAccent),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Available: 16,400 Liters', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text('Status: Ample for 14 Drip Cycles', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.healthyGreen)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGaugeCard(String label, String value, IconData icon, Color color, String status) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
          Text(status, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildNpkRow(String label, double val, double max, Color color, String note) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text('${val.toInt()} mg/kg', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (val / max).clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: AppColors.borderSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(note, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      ],
    );
  }
}
