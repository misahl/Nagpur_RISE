import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/drone_mission_model.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';

class DroneMonitoringScreen extends StatefulWidget {
  const DroneMonitoringScreen({super.key});

  @override
  State<DroneMonitoringScreen> createState() => _DroneMonitoringScreenState();
}

class _DroneMonitoringScreenState extends State<DroneMonitoringScreen> {
  String _selectedZoneFrom = 'Zone A';
  String _selectedZoneTo = 'Zone B';
  double _altitude = 32.0;

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final droneService = farmState.droneService;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Autonomous Drone Survey'),
      ),
      body: StreamBuilder<DroneMissionModel>(
        stream: droneService.missionStream,
        initialData: droneService.activeMission,
        builder: (context, snapshot) {
          final mission = snapshot.data ?? droneService.activeMission;
          final isFlightActive = mission.status == 'In Flight' || mission.status == 'Scanning';
          final isCompleted = mission.status == 'Completed';

          Color statusColor = AppColors.primaryGreen;
          if (isFlightActive) statusColor = AppColors.primaryOrange;
          if (mission.status == 'Paused') statusColor = AppColors.moderateYellow;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Live Aerial Camera Feed Simulation
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderSubtle),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset('assets/images/drone_orchard.jpg', fit: BoxFit.cover),

                        // Telemetry HUD overlay
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(180),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(radius: 4, backgroundColor: statusColor),
                                const SizedBox(width: 6),
                                Text(
                                  'MAVLINK: ${mission.status.toUpperCase()}',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(180),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.battery_charging_full, color: Colors.greenAccent, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${mission.batteryPercent}%',
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Center reticle
                        Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white70, width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(Icons.add, color: Colors.white70, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Telemetry Metrics Row
                Row(
                  children: [
                    _buildTelemetryTile('Altitude', '${mission.altitudeMeters.toInt()}m', Icons.height, Colors.indigo),
                    const SizedBox(width: 8),
                    _buildTelemetryTile('Coverage', '${mission.coveragePercent}%', Icons.crop_free, AppColors.primaryOrange),
                    const SizedBox(width: 8),
                    _buildTelemetryTile('Frames', '${mission.imagesCaptured}', Icons.camera_alt_outlined, AppColors.primaryGreen),
                    const SizedBox(width: 8),
                    _buildTelemetryTile('Hotspots', '${mission.diseaseHotspotsFound}', Icons.warning_amber_rounded, AppColors.diseasedRed),
                  ],
                ),
                const SizedBox(height: 16),

                // Mission Status Card
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            mission.missionName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withAlpha(25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              mission.status,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: statusColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Flight Trajectory: ${mission.currentRoute}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: mission.coveragePercent / 100.0,
                        backgroundColor: AppColors.borderSubtle,
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Mission Completed Summary Banner
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
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
                            Icon(Icons.check_circle, color: AppColors.healthyGreen),
                            SizedBox(width: 8),
                            Text(
                              'Drone Scan Completed',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.greenDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('• Total Area Scanned: ${mission.areaScannedAcres.toStringAsFixed(1)} Acres'),
                        Text('• Multispectral Images Captured: ${mission.imagesCaptured}'),
                        Text('• Suspected Hotspots Identified: ${mission.diseaseHotspotsFound} in Zone B & C'),
                        Text('• Overall Orchard Health Index: ${mission.averageCropHealth}%'),
                      ],
                    ),
                  ),

                // Mission Control Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isFlightActive
                            ? null
                            : () {
                                droneService.startMission(
                                  farmId: farmState.currentFarm.id,
                                  zoneFrom: _selectedZoneFrom,
                                  zoneTo: _selectedZoneTo,
                                  altitude: _altitude,
                                );
                              },
                        icon: const Icon(Icons.flight_takeoff),
                        label: const Text('START MISSION'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isFlightActive ? () => droneService.pauseMission() : null,
                        icon: const Icon(Icons.pause),
                        label: const Text('PAUSE'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => droneService.returnHome(),
                        icon: const Icon(Icons.home),
                        label: const Text('RETURN'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.diseasedRed,
                          side: const BorderSide(color: AppColors.diseasedRed),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Flight Parameters Configuration
                const Text(
                  'Flight Mission Parameters',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedZoneFrom,
                        decoration: const InputDecoration(labelText: 'Origin Zone'),
                        items: ['Zone A', 'Zone B', 'Zone C', 'Zone D'].map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
                        onChanged: (val) => setState(() => _selectedZoneFrom = val ?? 'Zone A'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedZoneTo,
                        decoration: const InputDecoration(labelText: 'Target Zone'),
                        items: ['Zone A', 'Zone B', 'Zone C', 'Zone D'].map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
                        onChanged: (val) => setState(() => _selectedZoneTo = val ?? 'Zone B'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Flight Altitude:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        Text('${_altitude.toInt()} Meters', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _altitude,
                      min: 15,
                      max: 80,
                      divisions: 13,
                      activeColor: AppColors.primaryOrange,
                      onChanged: (val) => setState(() => _altitude = val),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTelemetryTile(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
