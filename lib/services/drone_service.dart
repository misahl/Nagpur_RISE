import 'dart:async';
import '../models/drone_mission_model.dart';

abstract class DroneService {
  DroneMissionModel get activeMission;
  Stream<DroneMissionModel> get missionStream;
  void startMission({required String farmId, required String zoneFrom, required String zoneTo, double altitude = 32.0});
  void pauseMission();
  void resumeMission();
  void returnHome();
}

class SimulatedDroneService implements DroneService {
  late DroneMissionModel _mission;
  final _controller = StreamController<DroneMissionModel>.broadcast();
  Timer? _flightTimer;

  SimulatedDroneService() {
    _mission = DroneMissionModel(
      id: 'mission_001',
      farmId: 'farm_01',
      missionName: 'Autonomous Crop Health Scan',
      currentRoute: 'Zone A → Zone B',
      status: 'Connected',
      batteryPercent: 78,
      altitudeMeters: 32.0,
      coveragePercent: 67,
      imagesCaptured: 142,
      areaScannedAcres: 2.8,
      diseaseHotspotsFound: 3,
      averageCropHealth: 88.5,
      startTime: DateTime.now().subtract(const Duration(minutes: 14)),
    );
  }

  @override
  DroneMissionModel get activeMission => _mission;

  @override
  Stream<DroneMissionModel> get missionStream => _controller.stream;

  @override
  void startMission({
    required String farmId,
    required String zoneFrom,
    required String zoneTo,
    double altitude = 32.0,
  }) {
    _flightTimer?.cancel();
    _mission = _mission.copyWith(
      status: 'In Flight',
      altitudeMeters: altitude,
      coveragePercent: 10,
      batteryPercent: 95,
      imagesCaptured: 12,
      diseaseHotspotsFound: 1,
    );
    _controller.add(_mission);

    _flightTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_mission.status == 'In Flight' || _mission.status == 'Scanning') {
        int nextCoverage = _mission.coveragePercent + 6;
        int nextBattery = (_mission.batteryPercent - 1).clamp(15, 100);
        int nextImages = _mission.imagesCaptured + 8;
        int nextHotspots = nextCoverage > 50 ? 3 : 1;

        if (nextCoverage >= 100) {
          _mission = _mission.copyWith(
            status: 'Completed',
            coveragePercent: 100,
            batteryPercent: nextBattery,
            imagesCaptured: nextImages,
            diseaseHotspotsFound: nextHotspots,
            areaScannedAcres: 4.2,
          );
          _flightTimer?.cancel();
        } else {
          _mission = _mission.copyWith(
            status: 'Scanning',
            coveragePercent: nextCoverage,
            batteryPercent: nextBattery,
            imagesCaptured: nextImages,
            diseaseHotspotsFound: nextHotspots,
            areaScannedAcres: (nextCoverage * 0.042),
          );
        }
        _controller.add(_mission);
      }
    });
  }

  @override
  void pauseMission() {
    _flightTimer?.cancel();
    _mission = _mission.copyWith(status: 'Paused');
    _controller.add(_mission);
  }

  @override
  void resumeMission() {
    _mission = _mission.copyWith(status: 'Scanning');
    _controller.add(_mission);
    startMission(
      farmId: _mission.farmId,
      zoneFrom: 'Zone A',
      zoneTo: 'Zone B',
      altitude: _mission.altitudeMeters,
    );
  }

  @override
  void returnHome() {
    _flightTimer?.cancel();
    _mission = _mission.copyWith(status: 'Returning', altitudeMeters: 20.0);
    _controller.add(_mission);

    Future.delayed(const Duration(seconds: 3), () {
      _mission = _mission.copyWith(status: 'Connected', altitudeMeters: 0.0);
      _controller.add(_mission);
    });
  }

  void dispose() {
    _flightTimer?.cancel();
    _controller.close();
  }
}
