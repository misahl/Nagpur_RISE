import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../services/farm_state_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/health_card.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/alert_card.dart';
import '../../widgets/task_card.dart';
import '../../widgets/quick_action_item.dart';
import '../../widgets/farm_map_widget.dart';
import '../farm/farm_map_screen.dart';
import '../farm/add_farm_screen.dart';
import '../ai_scan/ai_crop_scan_screen.dart';
import '../ai_scan/fruit_detection_screen.dart';
import '../drone/drone_monitoring_screen.dart';
import '../sensors/iot_sensors_screen.dart';
import '../irrigation/smart_irrigation_screen.dart';
import '../weather/weather_screen.dart';
import '../tasks/tasks_screen.dart';
import '../analytics/analytics_screen.dart';
import '../analytics/crop_health_screen.dart';
import '../alerts/alerts_screen.dart';
import '../reports/reports_screen.dart';
import '../assistant/ai_assistant_screen.dart';
import '../traceability/harvest_batches_screen.dart';

class FarmerDashboardScreen extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const FarmerDashboardScreen({super.key, this.onNavigateToTab});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final auth = Provider.of<AuthService>(context);
    final farm = farmState.currentFarm;
    final userName = auth.currentUser?.name ?? 'Rajesh Patil';
    final sensor = farmState.sensorService.getLatestReading(farm.id, 'zone_b');

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Welcome Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryOrange, AppColors.orangeDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withAlpha(80),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getGreeting()}, $userName',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Smart farming powered by AI • ${farm.name}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withAlpha(220),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withAlpha(80)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${farmState.weather.temperature.toInt()}°C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 1. Farm Health Card
            HealthCard(
              overallHealth: farm.healthScore,
              diseaseRisk: farm.diseaseRisk,
              pestRisk: farm.pestRisk,
              soilMoisture: sensor.soilMoisture,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CropHealthScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // 2. Weather & Key Metrics Grid
            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Weather',
                    value: '${farmState.weather.temperature.toInt()}°C',
                    subtitle: 'Rain ${farmState.weather.rainProbability}%',
                    icon: Icons.cloud_outlined,
                    iconColor: AppColors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WeatherScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MetricCard(
                    title: 'Soil Moisture',
                    value: '${sensor.soilMoisture.toInt()}%',
                    subtitle: sensor.soilMoisture < 35 ? 'Dry (Zone B)' : 'Optimal',
                    icon: Icons.water_drop_outlined,
                    iconColor: sensor.soilMoisture < 35 ? AppColors.diseasedRed : AppColors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SmartIrrigationScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Farm Area',
                    value: '${farm.areaAcres} Acres',
                    subtitle: '4 Active Zones',
                    icon: Icons.crop_square_outlined,
                    iconColor: AppColors.primaryGreen,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FarmMapScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MetricCard(
                    title: 'Orange Trees',
                    value: '${farm.numberOfTrees}',
                    subtitle: farm.orangeVariety.split(' ').first,
                    icon: Icons.park_outlined,
                    iconColor: AppColors.primaryOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FarmMapScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Quick Actions Horizontal Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                    );
                  },
                  child: const Text('All Tools', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  QuickActionItem(
                    label: 'AI Scan',
                    icon: Icons.camera_alt_outlined,
                    color: AppColors.primaryOrange,
                    onTap: () {
                      if (onNavigateToTab != null) {
                        onNavigateToTab!(2);
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AiCropScanScreen()));
                      }
                    },
                  ),
                  QuickActionItem(
                    label: 'Add Farm',
                    icon: Icons.add_business_outlined,
                    color: AppColors.primaryGreen,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AddFarmScreen()));
                    },
                  ),
                  QuickActionItem(
                    label: 'Farm Map',
                    icon: Icons.map_outlined,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FarmMapScreen()));
                    },
                  ),
                  QuickActionItem(
                    label: 'Drone Scan',
                    icon: Icons.flight_takeoff_outlined,
                    color: Colors.indigo,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const DroneMonitoringScreen()));
                    },
                  ),
                  QuickActionItem(
                    label: 'Irrigation',
                    icon: Icons.water_drop,
                    color: AppColors.blueAccent,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SmartIrrigationScreen()));
                    },
                  ),
                  QuickActionItem(
                    label: 'Fruit AI',
                    icon: Icons.all_out_outlined,
                    color: Colors.amber.shade900,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FruitDetectionScreen()));
                    },
                  ),
                  QuickActionItem(
                    label: 'IoT Sensors',
                    icon: Icons.sensors_outlined,
                    color: Colors.cyan.shade700,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const IoTSensorsScreen()));
                    },
                  ),
                  QuickActionItem(
                    label: 'Traceability',
                    icon: Icons.qr_code_2_outlined,
                    color: Colors.deepPurple,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HarvestBatchesScreen()));
                    },
                  ),
                  QuickActionItem(
                    label: 'AI Chat',
                    icon: Icons.chat_bubble_outline,
                    color: AppColors.primaryGreen,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AiAssistantScreen()));
                    },
                  ),
                  QuickActionItem(
                    label: 'Report PDF',
                    icon: Icons.picture_as_pdf_outlined,
                    color: Colors.red.shade700,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen()));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Live Farm Map Preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Orchard Health Heatmap',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FarmMapScreen()));
                  },
                  icon: const Icon(Icons.fullscreen, size: 16),
                  label: const Text('Open Map', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            FarmMapWidget(
              farm: farm,
              zones: farmState.zones,
              height: 200,
              isInteractive: true,
              onZoneSelected: (zone) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FarmMapScreen()));
              },
            ),
            const SizedBox(height: 20),

            // Today's Tasks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Tasks",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TasksScreen()));
                  },
                  child: const Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            ...farmState.tasks.take(2).map((task) {
              return TaskCard(
                task: task,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TasksScreen()));
                },
                onStatusToggle: (val) {
                  farmState.completeTask(
                    taskId: task.id,
                    inspectionNotes: 'Marked completed from farmer dashboard.',
                  );
                },
              );
            }),
            const SizedBox(height: 16),

            // Recent Alerts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Alerts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: () {
                    if (onNavigateToTab != null) {
                      onNavigateToTab!(3);
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AlertsScreen()));
                    }
                  },
                  child: const Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            ...farmState.alerts.take(2).map((alert) {
              return AlertCard(
                alert: alert,
                onTap: () {
                  if (onNavigateToTab != null) {
                    onNavigateToTab!(3);
                  }
                },
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
