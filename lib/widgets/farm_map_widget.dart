import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/zone_model.dart';
import '../models/farm_model.dart';
import '../core/constants/app_colors.dart';

class FarmMapWidget extends StatefulWidget {
  final FarmModel farm;
  final List<ZoneModel> zones;
  final Function(ZoneModel)? onZoneSelected;
  final bool showHeatmap;
  final bool showDrone;
  final bool showSensors;
  final bool isInteractive;
  final double height;

  const FarmMapWidget({
    super.key,
    required this.farm,
    required this.zones,
    this.onZoneSelected,
    this.showHeatmap = false,
    this.showDrone = true,
    this.showSensors = true,
    this.isInteractive = true,
    this.height = 360,
  });

  @override
  State<FarmMapWidget> createState() => _FarmMapWidgetState();
}

class _FarmMapWidgetState extends State<FarmMapWidget> {
  late final MapController _mapController;
  ZoneModel? _selectedZone;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.zones.isNotEmpty) {
      _selectedZone = widget.zones.first;
    }
  }

  Color _getPolygonColor(ZoneModel zone) {
    if (widget.showHeatmap) {
      if (zone.statusColor == 'RED') return Colors.red.withAlpha(160);
      if (zone.statusColor == 'ORANGE') return Colors.deepOrange.withAlpha(160);
      if (zone.statusColor == 'YELLOW') return Colors.amber.withAlpha(160);
      return Colors.green.withAlpha(160);
    }

    switch (zone.statusColor.toUpperCase()) {
      case 'GREEN':
        return AppColors.healthyGreen.withAlpha(110);
      case 'YELLOW':
        return AppColors.moderateYellow.withAlpha(120);
      case 'ORANGE':
        return AppColors.inspectionOrange.withAlpha(130);
      case 'RED':
        return AppColors.diseasedRed.withAlpha(150);
      default:
        return AppColors.healthyGreen.withAlpha(100);
    }
  }

  List<Polygon> _buildZonePolygons() {
    // Generate distinct geospatial quadrangular boundaries for 4 zones in Kalmeshwar farm
    final centerLat = widget.farm.latitude;
    final centerLng = widget.farm.longitude;

    final Map<String, List<LatLng>> zoneCoords = {
      'zone_a': [
        LatLng(centerLat + 0.0018, centerLng - 0.0018),
        LatLng(centerLat + 0.0018, centerLng),
        LatLng(centerLat + 0.0002, centerLng),
        LatLng(centerLat + 0.0002, centerLng - 0.0018),
      ],
      'zone_b': [
        LatLng(centerLat + 0.0018, centerLng),
        LatLng(centerLat + 0.0018, centerLng + 0.0018),
        LatLng(centerLat + 0.0002, centerLng + 0.0018),
        LatLng(centerLat + 0.0002, centerLng),
      ],
      'zone_c': [
        LatLng(centerLat + 0.0002, centerLng - 0.0018),
        LatLng(centerLat + 0.0002, centerLng),
        LatLng(centerLat - 0.0014, centerLng),
        LatLng(centerLat - 0.0014, centerLng - 0.0018),
      ],
      'zone_d': [
        LatLng(centerLat + 0.0002, centerLng),
        LatLng(centerLat + 0.0002, centerLng + 0.0018),
        LatLng(centerLat - 0.0014, centerLng + 0.0018),
        LatLng(centerLat - 0.0014, centerLng),
      ],
    };

    return widget.zones.map((zone) {
      final points = zoneCoords[zone.id] ?? [
        LatLng(centerLat + 0.0005, centerLng - 0.0005),
        LatLng(centerLat + 0.0005, centerLng + 0.0005),
        LatLng(centerLat - 0.0005, centerLng + 0.0005),
        LatLng(centerLat - 0.0005, centerLng - 0.0005),
      ];

      final isSelected = _selectedZone?.id == zone.id;

      return Polygon(
        points: points,
        color: _getPolygonColor(zone),
        borderColor: isSelected ? Colors.white : zone.displayColor,
        borderStrokeWidth: isSelected ? 3.5 : 2.0,
      );
    }).toList();
  }

  List<Marker> _buildMapMarkers() {
    final markers = <Marker>[];
    final centerLat = widget.farm.latitude;
    final centerLng = widget.farm.longitude;

    // Zone Label Markers
    for (var zone in widget.zones) {
      markers.add(
        Marker(
          point: LatLng(zone.centerLat, zone.centerLng),
          width: 100,
          height: 38,
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedZone = zone);
              if (widget.onZoneSelected != null) {
                widget.onZoneSelected!(zone);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: zone.displayColor, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 4, backgroundColor: zone.displayColor),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      zone.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // IoT Sensors Pins
    if (widget.showSensors) {
      markers.add(
        Marker(
          point: LatLng(centerLat + 0.0008, centerLng + 0.0009),
          width: 34,
          height: 34,
          child: _buildPinBadge(Icons.sensors, Colors.teal, 'Sensor Hub B'),
        ),
      );
      // Water Tank
      markers.add(
        Marker(
          point: LatLng(centerLat - 0.0003, centerLng - 0.0002),
          width: 34,
          height: 34,
          child: _buildPinBadge(Icons.water, Colors.blue, 'Main Tank 82%'),
        ),
      );
      // Flagged Tree B-042
      markers.add(
        Marker(
          point: LatLng(centerLat + 0.0010, centerLng + 0.0011),
          width: 36,
          height: 36,
          child: _buildPinBadge(Icons.park, AppColors.diseasedRed, 'Tree B-042 (Canker)'),
        ),
      );
    }

    // Drone flight position marker
    if (widget.showDrone) {
      markers.add(
        Marker(
          point: LatLng(centerLat + 0.0004, centerLng + 0.0005),
          width: 42,
          height: 42,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withAlpha(120),
                  blurRadius: 10,
                  spreadRadius: 3,
                )
              ],
            ),
            child: const Icon(Icons.flight, color: Colors.white, size: 22),
          ),
        ),
      );
    }

    return markers;
  }

  Widget _buildPinBadge(IconData icon, Color color, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(widget.farm.latitude, widget.farm.longitude),
                initialZoom: 16.2,
                interactionOptions: InteractionOptions(
                  flags: widget.isInteractive ? InteractiveFlag.all : InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.orangeai.app',
                ),
                PolygonLayer(polygons: _buildZonePolygons()),
                MarkerLayer(markers: _buildMapMarkers()),
              ],
            ),

            // Map Controls Overlay (Zoom In, Zoom Out, Recenter)
            Positioned(
              right: 12,
              top: 12,
              child: Column(
                children: [
                  _buildControlBtn(Icons.add, () {
                    _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 0.8);
                  }),
                  const SizedBox(height: 6),
                  _buildControlBtn(Icons.remove, () {
                    _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 0.8);
                  }),
                  const SizedBox(height: 6),
                  _buildControlBtn(Icons.my_location, () {
                    _mapController.move(LatLng(widget.farm.latitude, widget.farm.longitude), 16.2);
                  }),
                ],
              ),
            ),

            // Map Legend Overlay
            Positioned(
              left: 12,
              top: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(235),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLegendItem('Healthy', AppColors.healthyGreen),
                    const SizedBox(width: 8),
                    _buildLegendItem('Mod Risk', AppColors.moderateYellow),
                    const SizedBox(width: 8),
                    _buildLegendItem('Inspect', AppColors.inspectionOrange),
                    const SizedBox(width: 8),
                    _buildLegendItem('Disease', AppColors.diseasedRed),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildControlBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
