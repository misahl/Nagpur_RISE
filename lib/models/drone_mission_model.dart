class DroneMissionModel {
  final String id;
  final String farmId;
  final String missionName;
  final String currentRoute; // e.g. "Zone A → Zone B"
  final String status; // 'Connected', 'In Flight', 'Scanning', 'Returning', 'Completed', 'Paused'
  final int batteryPercent; // e.g. 78
  final double altitudeMeters; // e.g. 32.0
  final int coveragePercent; // e.g. 67
  final int imagesCaptured;
  final double areaScannedAcres;
  final int diseaseHotspotsFound;
  final double averageCropHealth;
  final DateTime startTime;

  DroneMissionModel({
    required this.id,
    required this.farmId,
    required this.missionName,
    required this.currentRoute,
    required this.status,
    required this.batteryPercent,
    required this.altitudeMeters,
    required this.coveragePercent,
    required this.imagesCaptured,
    required this.areaScannedAcres,
    required this.diseaseHotspotsFound,
    required this.averageCropHealth,
    required this.startTime,
  });

  DroneMissionModel copyWith({
    String? status,
    int? batteryPercent,
    double? altitudeMeters,
    int? coveragePercent,
    int? imagesCaptured,
    double? areaScannedAcres,
    int? diseaseHotspotsFound,
    double? averageCropHealth,
  }) {
    return DroneMissionModel(
      id: id,
      farmId: farmId,
      missionName: missionName,
      currentRoute: currentRoute,
      status: status ?? this.status,
      batteryPercent: batteryPercent ?? this.batteryPercent,
      altitudeMeters: altitudeMeters ?? this.altitudeMeters,
      coveragePercent: coveragePercent ?? this.coveragePercent,
      imagesCaptured: imagesCaptured ?? this.imagesCaptured,
      areaScannedAcres: areaScannedAcres ?? this.areaScannedAcres,
      diseaseHotspotsFound: diseaseHotspotsFound ?? this.diseaseHotspotsFound,
      averageCropHealth: averageCropHealth ?? this.averageCropHealth,
      startTime: startTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmId': farmId,
      'missionName': missionName,
      'currentRoute': currentRoute,
      'status': status,
      'batteryPercent': batteryPercent,
      'altitudeMeters': altitudeMeters,
      'coveragePercent': coveragePercent,
      'imagesCaptured': imagesCaptured,
      'areaScannedAcres': areaScannedAcres,
      'diseaseHotspotsFound': diseaseHotspotsFound,
      'averageCropHealth': averageCropHealth,
      'startTime': startTime.toIso8601String(),
    };
  }

  factory DroneMissionModel.fromMap(Map<String, dynamic> map) {
    return DroneMissionModel(
      id: map['id'] ?? '',
      farmId: map['farmId'] ?? '',
      missionName: map['missionName'] ?? 'Autonomous Orchard Health Scan',
      currentRoute: map['currentRoute'] ?? 'Zone A → Zone B',
      status: map['status'] ?? 'Connected',
      batteryPercent: (map['batteryPercent'] as num?)?.toInt() ?? 78,
      altitudeMeters: (map['altitudeMeters'] as num?)?.toDouble() ?? 32.0,
      coveragePercent: (map['coveragePercent'] as num?)?.toInt() ?? 67,
      imagesCaptured: (map['imagesCaptured'] as num?)?.toInt() ?? 142,
      areaScannedAcres: (map['areaScannedAcres'] as num?)?.toDouble() ?? 2.8,
      diseaseHotspotsFound: (map['diseaseHotspotsFound'] as num?)?.toInt() ?? 3,
      averageCropHealth: (map['averageCropHealth'] as num?)?.toDouble() ?? 88.5,
      startTime: map['startTime'] != null 
          ? DateTime.parse(map['startTime']) 
          : DateTime.now(),
    );
  }
}
