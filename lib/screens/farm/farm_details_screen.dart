import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/farm_model.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/farm_map_widget.dart';
import '../../widgets/health_card.dart';
import 'farm_map_screen.dart';
import 'zone_details_screen.dart';
import 'add_farm_screen.dart';
import 'tree_list_screen.dart';

class FarmDetailsScreen extends StatelessWidget {
  final FarmModel farm;

  const FarmDetailsScreen({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final zones = farmState.zones;

    return Scaffold(
      appBar: AppBar(
        title: Text(farm.name),
        actions: [
          IconButton(
            tooltip: 'Add New Farm',
            icon: const Icon(Icons.add_business_outlined, color: AppColors.primaryOrange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddFarmScreen()),
              );
            },
          ),
          IconButton(
            tooltip: 'Tree Registry',
            icon: const Icon(Icons.forest_outlined, color: AppColors.primaryGreen),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TreeListScreen()),
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
            // Farm Map Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Orchard Geospatial Map',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FarmMapScreen()),
                    );
                  },
                  icon: const Icon(Icons.open_in_full, size: 14),
                  label: const Text('Interactive Map', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            FarmMapWidget(
              farm: farm,
              zones: zones,
              height: 220,
              onZoneSelected: (zone) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ZoneDetailsScreen(zone: zone)),
                );
              },
            ),
            const SizedBox(height: 16),

            // Health Card
            HealthCard(
              overallHealth: farm.healthScore,
              diseaseRisk: farm.diseaseRisk,
              pestRisk: farm.pestRisk,
              soilMoisture: 64.0,
            ),
            const SizedBox(height: 16),

            // Farm Details Specification Grid
            const Text(
              'Farm Specifications & Agronomics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
                  _buildDetailRow('Location', farm.location, Icons.location_on_outlined),
                  const Divider(height: 20),
                  _buildDetailRow('Total Area', '${farm.areaAcres} Acres', Icons.square_foot_outlined),
                  const Divider(height: 20),
                  _buildDetailRow('Orange Trees', '${farm.numberOfTrees} Trees', Icons.park_outlined),
                  const Divider(height: 20),
                  _buildDetailRow('Citrus Variety', farm.orangeVariety, Icons.eco_outlined),
                  const Divider(height: 20),
                  _buildDetailRow('Average Tree Age', '${farm.treeAgeYears} Years (Bearing Stage)', Icons.history),
                  const Divider(height: 20),
                  _buildDetailRow('Soil Classification', farm.soilCondition, Icons.layers_outlined),
                  const Divider(height: 20),
                  _buildDetailRow('Irrigation Type', farm.irrigationType, Icons.water_outlined),
                  const Divider(height: 20),
                  _buildDetailRow('Irrigation Schedule', farm.irrigationStatus, Icons.timer_outlined),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Zones List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Farm Zones Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text('${zones.length} Zones', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
            const SizedBox(height: 10),
            ...zones.map((zone) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: zone.displayColor.withAlpha(30),
                    child: CircleAvatar(radius: 8, backgroundColor: zone.displayColor),
                  ),
                  title: Row(
                    children: [
                      Text(zone.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: zone.displayColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          zone.statusLabel,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: zone.displayColor),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${zone.numberOfTrees} Trees • Soil Moisture: ${zone.soilMoisture.toInt()}% • Cases: ${zone.diseaseCases}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ZoneDetailsScreen(zone: zone)),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryOrange),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
