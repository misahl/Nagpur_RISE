class SensorReadingModel {
  final String id;
  final String farmId;
  final String zoneId;
  final double soilMoisture; // %
  final double temperature; // °C
  final double humidity; // %
  final double soilPh;
  final double nitrogen; // mg/kg
  final double phosphorus; // mg/kg
  final double potassium; // mg/kg
  final double waterTankLevel; // %
  final DateTime timestamp;

  SensorReadingModel({
    required this.id,
    required this.farmId,
    required this.zoneId,
    required this.soilMoisture,
    required this.temperature,
    required this.humidity,
    required this.soilPh,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.waterTankLevel,
    required this.timestamp,
  });

  SensorReadingModel copyWith({
    double? soilMoisture,
    double? temperature,
    double? humidity,
    double? soilPh,
    double? nitrogen,
    double? phosphorus,
    double? potassium,
    double? waterTankLevel,
    DateTime? timestamp,
  }) {
    return SensorReadingModel(
      id: id,
      farmId: farmId,
      zoneId: zoneId,
      soilMoisture: soilMoisture ?? this.soilMoisture,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      soilPh: soilPh ?? this.soilPh,
      nitrogen: nitrogen ?? this.nitrogen,
      phosphorus: phosphorus ?? this.phosphorus,
      potassium: potassium ?? this.potassium,
      waterTankLevel: waterTankLevel ?? this.waterTankLevel,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmId': farmId,
      'zoneId': zoneId,
      'soilMoisture': soilMoisture,
      'temperature': temperature,
      'humidity': humidity,
      'soilPh': soilPh,
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'waterTankLevel': waterTankLevel,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SensorReadingModel.fromMap(Map<String, dynamic> map) {
    return SensorReadingModel(
      id: map['id'] ?? '',
      farmId: map['farmId'] ?? '',
      zoneId: map['zoneId'] ?? '',
      soilMoisture: (map['soilMoisture'] as num?)?.toDouble() ?? 64.0,
      temperature: (map['temperature'] as num?)?.toDouble() ?? 27.0,
      humidity: (map['humidity'] as num?)?.toDouble() ?? 71.0,
      soilPh: (map['soilPh'] as num?)?.toDouble() ?? 6.4,
      nitrogen: (map['nitrogen'] as num?)?.toDouble() ?? 72.0,
      phosphorus: (map['phosphorus'] as num?)?.toDouble() ?? 61.0,
      potassium: (map['potassium'] as num?)?.toDouble() ?? 68.0,
      waterTankLevel: (map['waterTankLevel'] as num?)?.toDouble() ?? 82.0,
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
    );
  }
}
