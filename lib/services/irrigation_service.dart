import 'dart:async';
import 'package:flutter/foundation.dart';

class ZoneIrrigationState {
  final String zoneId;
  final String zoneName;
  double soilMoisture;
  String status; // 'Normal', 'Dry', 'Moderate', 'Irrigating'
  bool isPumpActive;
  double flowRateLpm;
  double totalWaterUsedLiters;

  ZoneIrrigationState({
    required this.zoneId,
    required this.zoneName,
    required this.soilMoisture,
    required this.status,
    this.isPumpActive = false,
    this.flowRateLpm = 24.5,
    this.totalWaterUsedLiters = 450.0,
  });
}

class IrrigationService extends ChangeNotifier {
  final Map<String, ZoneIrrigationState> _zones = {
    'zone_a': ZoneIrrigationState(zoneId: 'zone_a', zoneName: 'Zone A', soilMoisture: 65.0, status: 'Normal'),
    'zone_b': ZoneIrrigationState(zoneId: 'zone_b', zoneName: 'Zone B', soilMoisture: 24.0, status: 'Dry'),
    'zone_c': ZoneIrrigationState(zoneId: 'zone_c', zoneName: 'Zone C', soilMoisture: 42.0, status: 'Moderate'),
    'zone_d': ZoneIrrigationState(zoneId: 'zone_d', zoneName: 'Zone D', soilMoisture: 58.0, status: 'Normal'),
  };

  Timer? _irrigationTimer;
  double _cumulativeLitersUsed = 2840.0;

  List<ZoneIrrigationState> get zoneStates => _zones.values.toList();
  double get cumulativeLitersUsed => _cumulativeLitersUsed;
  bool get isAnyPumpActive => _zones.values.any((z) => z.isPumpActive);

  String getAiRecommendation(bool isRainExpected) {
    if (isRainExpected) {
      return 'Rain forecast within 3-4 hours. Postponing irrigation cycle recommended to prevent waterlogging.';
    }
    final dryZones = _zones.values.where((z) => z.soilMoisture < 35.0).toList();
    if (dryZones.isNotEmpty) {
      return '${dryZones.map((z) => z.zoneName).join(', ')} soil moisture is below 35%. Immediate drip irrigation recommended.';
    }
    return 'All farm zones maintain optimal soil moisture tension (50% - 70%).';
  }

  void startIrrigation(String zoneId) {
    final zone = _zones[zoneId];
    if (zone == null) return;

    zone.isPumpActive = true;
    zone.status = 'Irrigating';
    notifyListeners();

    _irrigationTimer?.cancel();
    _irrigationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isAnyPumpActive) {
        timer.cancel();
        return;
      }

      for (var z in _zones.values) {
        if (z.isPumpActive) {
          z.soilMoisture = (z.soilMoisture + 1.2).clamp(0.0, 75.0);
          z.totalWaterUsedLiters += 2.8;
          _cumulativeLitersUsed += 2.8;

          if (z.soilMoisture >= 68.0) {
            z.isPumpActive = false;
            z.status = 'Normal';
          }
        }
      }
      notifyListeners();
    });
  }

  void stopIrrigation(String zoneId) {
    final zone = _zones[zoneId];
    if (zone == null) return;

    zone.isPumpActive = false;
    zone.status = zone.soilMoisture < 35.0 ? 'Dry' : (zone.soilMoisture < 50.0 ? 'Moderate' : 'Normal');
    notifyListeners();
  }

  void stopAll() {
    for (var z in _zones.values) {
      z.isPumpActive = false;
      z.status = z.soilMoisture < 35.0 ? 'Dry' : (zoneMoistureToStatus(z.soilMoisture));
    }
    _irrigationTimer?.cancel();
    notifyListeners();
  }

  String zoneMoistureToStatus(double moisture) {
    if (moisture < 35) return 'Dry';
    if (moisture < 50) return 'Moderate';
    return 'Normal';
  }

  @override
  void dispose() {
    _irrigationTimer?.cancel();
    super.dispose();
  }
}
