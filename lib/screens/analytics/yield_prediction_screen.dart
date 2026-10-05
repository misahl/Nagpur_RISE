import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';

class YieldPredictionScreen extends StatelessWidget {
  const YieldPredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final farm = farmState.currentFarm;

    final yieldResult = farmState.yieldService.calculateYield(
      numberOfTrees: farm.numberOfTrees,
      treeAgeYears: farm.treeAgeYears,
      cropHealthScore: farm.healthScore,
      diseaseRisk: farm.diseaseRisk,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Harvest Yield Forecast'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Estimated Yield Hero Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryOrange, Color(0xFFE65100)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withAlpha(90),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'TOTAL ESTIMATED HARVEST',
                    style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${yieldResult.estimatedYieldTonnes} Tonnes',
                    style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Expected Range: ${yieldResult.minRangeTonnes} – ${yieldResult.maxRangeTonnes} Tonnes',
                    style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.event_available, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Harvest Window: ${yieldResult.estimatedHarvestWindow}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Yield Breakdown Key Figures
            Row(
              children: [
                _buildStatCard('Yield Per Tree', '${yieldResult.averageYieldPerTreeKg} kg', Icons.park_outlined, AppColors.primaryGreen),
                const SizedBox(width: 10),
                _buildStatCard('Projected Mandi Value', '₹${(yieldResult.revenueProjectionInr / 100000).toStringAsFixed(2)} Lakh', Icons.currency_rupee, Colors.indigo),
              ],
            ),
            const SizedBox(height: 16),

            // ML Model Input Variables Card
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
                  const Text('AI Yield Regression Parameters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 14),
                  _buildInputRow('Bearing Trees Count', '${farm.numberOfTrees} Trees', Icons.forest_outlined),
                  const Divider(height: 16),
                  _buildInputRow('Average Tree Age', '${farm.treeAgeYears} Years (Full Bearing)', Icons.cake_outlined),
                  const Divider(height: 16),
                  _buildInputRow('Canopy Health Index', '${farm.healthScore.toInt()}% Vigor', Icons.eco_outlined),
                  const Divider(height: 16),
                  _buildInputRow('Disease Depletion Discount', '${farm.diseaseRisk.toInt()}% (Zone B containment)', Icons.shield_outlined),
                  const Divider(height: 16),
                  _buildInputRow('Chilling Hours & Blossom Flushes', '140 hrs (Optimal spring set)', Icons.thermostat_outlined),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contributing Factors Insights
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.greenSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.healthyGreen.withAlpha(80)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: AppColors.healthyGreen, size: 20),
                      SizedBox(width: 8),
                      Text('Agronomist Yield Optimization Advice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.greenDark)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...yieldResult.contributingFactors.map((factor) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check, size: 16, color: AppColors.healthyGreen),
                          const SizedBox(width: 8),
                          Expanded(child: Text(factor, style: const TextStyle(fontSize: 12, height: 1.3))),
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

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryOrange),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
