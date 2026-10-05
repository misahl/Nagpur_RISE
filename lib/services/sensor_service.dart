import 'dart:async';
import 'dart:math';
import '../models/sensor_reading_model.dart';

abstract class SensorService {
  Stream<SensorReadingModel> getSensorStream(String farmId, String zoneId);
  SensorReadingModel getLatestReading(String farmId, String zoneId);
}

class SimulatedSensorService implements SensorService {
  final _random = Random();
  final Map<String, SensorReadingModel> _cache = {};
  final _streamController = StreamController<SensorReadingModel>.broadcast();
  Timer? _ticker;

  SimulatedSensorService() {
    _startSimulating();
  }

  void _startSimulating() {
    _ticker = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_cache.isNotEmpty) {
        final key = _cache.keys.first;
        final current = _cache[key]!;

        // Subtle realistic environmental variations
        final double deltaMoist = (_random.nextDouble() - 0.48) * 0.4;
        final double deltaTemp = (_random.nextDouble() - 0.5) * 0.2;
        final double deltaHumid = (_random.nextDouble() - 0.5) * 0.3;

        final updated = current.copyWith(
          soilMoisture: (current.soilMoisture + deltaMoist).clamp(18.0, 95.0),
          temperature: (current.temperature + deltaTemp).clamp(18.0, 42.0),
          humidity: (current.humidity + deltaHumid).clamp(30.0, 95.0),
          timestamp: DateTime.now(),
        );

        _cache[key] = updated;
        _streamController.add(updated);
      }
    });
  }

  @override
  SensorReadingModel getLatestReading(String farmId, String zoneId) {
    final key = '${farmId}_$zoneId';
    if (!_cache.containsKey(key)) {
      // Default initial baseline requested by user
      _cache[key] = SensorReadingModel(
        id: 'sensor_${DateTime.now().millisecondsSinceEpoch}',
        farmId: farmId,
        zoneId: zoneId,
        soilMoisture: zoneId == 'zone_b' ? 24.0 : 64.0, // Zone B is dry initially as per demo flow
        temperature: 27.0,
        humidity: 71.0,
        soilPh: 6.4,
        nitrogen: 72.0,
        phosphorus: 61.0,
        potassium: 68.0,
        waterTankLevel: 82.0,
        timestamp: DateTime.now(),
      );
    }
    return _cache[key]!;
  }

  @override
  Stream<SensorReadingModel> getSensorStream(String farmId, String zoneId) {
    return _streamController.stream;
  }

  void updateMoistureForIrrigation(String farmId, String zoneId, double newMoisture) {
    final key = '${farmId}_$zoneId';
    final current = getLatestReading(farmId, zoneId);
    final updated = current.copyWith(
      soilMoisture: newMoisture,
      waterTankLevel: (current.waterTankLevel - 2.5).clamp(10.0, 100.0),
      timestamp: DateTime.now(),
    );
    _cache[key] = updated;
    _streamController.add(updated);
  }

  void dispose() {
    _ticker?.cancel();
    _streamController.close();
  }
}
