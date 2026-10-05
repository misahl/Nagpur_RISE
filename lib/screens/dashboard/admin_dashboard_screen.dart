import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../services/farm_state_provider.dart';
import '../../services/auth_service.dart';
import '../farm/farm_details_screen.dart';
import 'main_navigation_scaffold.dart';
import '../auth/login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings_outlined, color: AppColors.primaryOrange),
            SizedBox(width: 8),
            Text('Nagpur Region Agri Admin'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Switch to Farmer View',
            icon: const Icon(Icons.swap_horiz, color: AppColors.primaryGreen),
            onPressed: () {
              auth.switchRole('Farmer');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigationScaffold()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Region Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.hub_outlined, color: Colors.white),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nagpur Citrus Belt Directorate',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Vidarbha Orange Farmers Monitoring & Analytics',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Top Key Performance Indicators Grid
            const Text(
              'Regional Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildMetricTile('Total Farmers', '48', Icons.people_outline, AppColors.primaryOrange),
                _buildMetricTile('Registered Farms', '62', Icons.agriculture_outlined, AppColors.primaryGreen),
                _buildMetricTile('Total Trees', '76,400', Icons.park_outlined, Colors.teal),
                _buildMetricTile('Cultivated Area', '284.5 Ac', Icons.landscape_outlined, Colors.blue),
                _buildMetricTile('Active Disease Cases', '14', Icons.coronavirus_outlined, AppColors.diseasedRed),
                _buildMetricTile('High Risk Farms', '3', Icons.warning_amber_rounded, AppColors.inspectionOrange),
                _buildMetricTile('Drone Missions', '128', Icons.flight_takeoff, Colors.indigo),
                _buildMetricTile('Avg Health Index', '88.2%', Icons.health_and_safety_outlined, AppColors.healthyGreen),
              ],
            ),
            const SizedBox(height: 20),

            // Disease Distribution Pie Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Disease Breakdown Across Region',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 36,
                          sections: [
                            PieChartSectionData(value: 45, title: '45%', color: AppColors.diseasedRed, radius: 40, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                            PieChartSectionData(value: 25, title: '25%', color: AppColors.moderateYellow, radius: 40, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                            PieChartSectionData(value: 15, title: '15%', color: Colors.purple, radius: 40, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                            PieChartSectionData(value: 15, title: '15%', color: AppColors.blueAccent, radius: 40, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        _buildLegendPill('Citrus Canker (45%)', AppColors.diseasedRed),
                        _buildLegendPill('Leafminer (25%)', AppColors.moderateYellow),
                        _buildLegendPill('Citrus Greening (15%)', Colors.purple),
                        _buildLegendPill('Fungal/Root Rot (15%)', AppColors.blueAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Registered Farms List
            const Text(
              'Registered Nagpur Farms',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            ...farmState.farms.map((farm) {
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.orangeSurface,
                    child: Text('🍊', style: TextStyle(fontSize: 18)),
                  ),
                  title: Text(farm.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('${farm.location} • ${farm.areaAcres} Ac • ${farm.numberOfTrees} Trees', style: const TextStyle(fontSize: 12)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.greenSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${farm.healthScore.toInt()}% Health',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FarmDetailsScreen(farm: farm)),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendPill(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
