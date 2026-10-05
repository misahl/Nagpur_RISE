import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/zone_model.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/farm_map_widget.dart';
import 'zone_details_screen.dart';
import '../ai_scan/ai_crop_scan_screen.dart';

class FarmMapScreen extends StatefulWidget {
  const FarmMapScreen({super.key});

  @override
  State<FarmMapScreen> createState() => _FarmMapScreenState();
}

class _FarmMapScreenState extends State<FarmMapScreen> {
  ZoneModel? _selectedZone;
  bool _showHeatmap = false;
  bool _showSensors = true;
  bool _showDrone = true;

  @override
  void initState() {
    super.initState();
    final farmState = Provider.of<FarmStateProvider>(context, listen: false);
    if (farmState.zones.isNotEmpty) {
      _selectedZone = farmState.zones[1]; // Default to Zone B as per demonstration flow
    }
  }

  void _onZoneTapped(ZoneModel zone) {
    setState(() => _selectedZone = zone);
  }

  void _showAddEntityDialog(String entityType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$entityType coordinate pin saved to Farm Boundary!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final farm = farmState.currentFarm;
    final zones = farmState.zones;

    return Scaffold(
      appBar: AppBar(
        title: Text('${farm.name} Map'),
        actions: [
          // Filter / Layers Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.layers_outlined),
            tooltip: 'Map Layers',
            onSelected: (val) {
              if (val == 'heatmap') setState(() => _showHeatmap = !_showHeatmap);
              if (val == 'sensors') setState(() => _showSensors = !_showSensors);
              if (val == 'drone') setState(() => _showDrone = !_showDrone);
            },
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                value: 'heatmap',
                checked: _showHeatmap,
                child: const Text('Disease Risk Heatmap'),
              ),
              CheckedPopupMenuItem(
                value: 'sensors',
                checked: _showSensors,
                child: const Text('IoT Sensors & Valves'),
              ),
              CheckedPopupMenuItem(
                value: 'drone',
                checked: _showDrone,
                child: const Text('Autonomous Drone Flight'),
              ),
            ],
          ),

          // Add Map Point Popup (Trees, Sensors, Water Tanks, Irrigation)
          PopupMenuButton<String>(
            icon: const Icon(Icons.add_location_alt_outlined, color: AppColors.primaryOrange),
            tooltip: 'Add Map Item',
            onSelected: (val) => _showAddEntityDialog(val),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'Tree', child: Text('Add Tree Pin')),
              PopupMenuItem(value: 'IoT Soil Sensor', child: Text('Add IoT Sensor')),
              PopupMenuItem(value: 'Water Tank', child: Text('Add Water Tank')),
              PopupMenuItem(value: 'Irrigation Valve', child: Text('Add Irrigation Point')),
              PopupMenuItem(value: 'Boundary Marker', child: Text('Draw Farm Boundary')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Main Interactive Map
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                FarmMapWidget(
                  farm: farm,
                  zones: zones,
                  height: double.infinity,
                  showHeatmap: _showHeatmap,
                  showSensors: _showSensors,
                  showDrone: _showDrone,
                  onZoneSelected: _onZoneTapped,
                ),

                // Heatmap Status Tag
                if (_showHeatmap)
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.whatshot, color: Colors.orange, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'HEATMAP OVERLAY ON',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Selected Zone Inspector Card
          if (_selectedZone != null)
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3))],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: _selectedZone!.displayColor.withAlpha(30),
                                child: CircleAvatar(radius: 6, backgroundColor: _selectedZone!.displayColor),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _selectedZone!.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _selectedZone!.displayColor.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _selectedZone!.statusLabel.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _selectedZone!.displayColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Zone Metrics Summary Grid
                      Row(
                        children: [
                          _buildZoneStatTile('Trees', '${_selectedZone!.numberOfTrees}', Icons.park_outlined),
                          const SizedBox(width: 8),
                          _buildZoneStatTile('Health', '${_selectedZone!.healthScore.toInt()}%', Icons.eco_outlined),
                          const SizedBox(width: 8),
                          _buildZoneStatTile('Cases', '${_selectedZone!.diseaseCases}', Icons.coronavirus_outlined),
                          const SizedBox(width: 8),
                          _buildZoneStatTile('Moisture', '${_selectedZone!.soilMoisture.toInt()}%', Icons.water_drop_outlined),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Inspection & Pest Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.bug_report_outlined, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                'Pest Risk: ${_selectedZone!.pestRisk}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedZone!.pestRisk == 'HIGH' ? AppColors.diseasedRed : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.event_available, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                'Last Inspection: ${_selectedZone!.lastInspectionDate}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AiCropScanScreen()),
                                );
                              },
                              icon: const Icon(Icons.camera_alt, size: 18),
                              label: const Text('AI Scan Zone'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryOrange,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ZoneDetailsScreen(zone: _selectedZone!),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.info_outline, size: 18),
                              label: const Text('Zone Details'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildZoneStatTile(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppColors.primaryOrange),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
