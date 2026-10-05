import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import 'crop_health_screen.dart';
import 'disease_risk_screen.dart';
import 'pest_monitoring_screen.dart';
import 'yield_prediction_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = '30 Days';

  final List<String> _periods = ['7 Days', '30 Days', '3 Months', '1 Year'];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orchard Farm Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Time range selector
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: _periods.map((p) {
                  final isSelected = _selectedPeriod == p;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPeriod = p),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isSelected ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : null,
                        ),
                        child: Text(
                          p,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.primaryOrange : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Navigation Pills to Detailed Analytics Modules
            Row(
              children: [
                _buildNavPill('Crop Health', Icons.eco, AppColors.healthyGreen, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CropHealthScreen()));
                }),
                const SizedBox(width: 8),
                _buildNavPill('Disease Risk', Icons.coronavirus, AppColors.diseasedRed, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DiseaseRiskScreen()));
                }),
                const SizedBox(width: 8),
                _buildNavPill('Pests', Icons.bug_report, AppColors.moderateYellow, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PestMonitoringScreen()));
                }),
                const SizedBox(width: 8),
                _buildNavPill('Yield', Icons.auto_graph, Colors.indigo, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const YieldPredictionScreen()));
                }),
              ],
            ),
            const SizedBox(height: 16),

            // Chart 1: Crop Health Over Time
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Crop Health Over Time (%)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('87% Current', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 82),
                                FlSpot(1, 84),
                                FlSpot(2, 83),
                                FlSpot(3, 86),
                                FlSpot(4, 88),
                                FlSpot(5, 87),
                              ],
                              isCurved: true,
                              color: AppColors.primaryGreen,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.primaryGreen.withAlpha(40),
                              ),
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Chart 2: Water Usage (Liters) Bar Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Weekly Drip Water Usage (Liters)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('Optimal Delivery', style: TextStyle(color: AppColors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
                      child: BarChart(
                        BarChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            _buildBarGroup(0, 420),
                            _buildBarGroup(1, 380),
                            _buildBarGroup(2, 450),
                            _buildBarGroup(3, 290),
                            _buildBarGroup(4, 510),
                            _buildBarGroup(5, 480),
                            _buildBarGroup(6, 310),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Chart 3: Soil Moisture & Temperature Correlation
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Soil Moisture vs Temperature', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('Root Zone', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 150,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [FlSpot(0, 68), FlSpot(1, 64), FlSpot(2, 60), FlSpot(3, 58), FlSpot(4, 62), FlSpot(5, 64)],
                              isCurved: true,
                              color: AppColors.blueAccent,
                              barWidth: 2.5,
                              dotData: const FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: const [FlSpot(0, 24), FlSpot(1, 26), FlSpot(2, 29), FlSpot(3, 31), FlSpot(4, 28), FlSpot(5, 27)],
                              isCurved: true,
                              color: AppColors.primaryOrange,
                              barWidth: 2.5,
                              dotData: const FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem('Soil Moisture (%)', AppColors.blueAccent),
                        const SizedBox(width: 16),
                        _buildLegendItem('Temperature (°C)', AppColors.primaryOrange),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavPill(String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(60)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.blueAccent,
          width: 14,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
