class FarmModel {
  final String id;
  final String ownerId;
  final String name;
  final String location;
  final double areaAcres;
  final String orangeVariety;
  final int numberOfTrees;
  final int treeAgeYears;
  final String soilType;
  final String irrigationType;
  final double healthScore;
  final double diseaseRisk;
  final double pestRisk;
  final String soilCondition;
  final double weatherTemp;
  final String irrigationStatus;
  final double latitude;
  final double longitude;

  FarmModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.location,
    required this.areaAcres,
    required this.orangeVariety,
    required this.numberOfTrees,
    required this.treeAgeYears,
    required this.soilType,
    required this.irrigationType,
    this.healthScore = 87.0,
    this.diseaseRisk = 12.0,
    this.pestRisk = 8.0,
    this.soilCondition = 'Optimal Sandy Loam',
    this.weatherTemp = 29.0,
    this.irrigationStatus = 'Scheduled',
    this.latitude = 21.1458,
    this.longitude = 79.0882,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'location': location,
      'areaAcres': areaAcres,
      'orangeVariety': orangeVariety,
      'numberOfTrees': numberOfTrees,
      'treeAgeYears': treeAgeYears,
      'soilType': soilType,
      'irrigationType': irrigationType,
      'healthScore': healthScore,
      'diseaseRisk': diseaseRisk,
      'pestRisk': pestRisk,
      'soilCondition': soilCondition,
      'weatherTemp': weatherTemp,
      'irrigationStatus': irrigationStatus,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory FarmModel.fromMap(Map<String, dynamic> map) {
    return FarmModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      areaAcres: (map['areaAcres'] as num?)?.toDouble() ?? 4.2,
      orangeVariety: map['orangeVariety'] ?? 'Nagpur Mandarin',
      numberOfTrees: (map['numberOfTrees'] as num?)?.toInt() ?? 1240,
      treeAgeYears: (map['treeAgeYears'] as num?)?.toInt() ?? 6,
      soilType: map['soilType'] ?? 'Black Soil / Sandy Loam',
      irrigationType: map['irrigationType'] ?? 'Drip Irrigation',
      healthScore: (map['healthScore'] as num?)?.toDouble() ?? 87.0,
      diseaseRisk: (map['diseaseRisk'] as num?)?.toDouble() ?? 12.0,
      pestRisk: (map['pestRisk'] as num?)?.toDouble() ?? 8.0,
      soilCondition: map['soilCondition'] ?? 'Good',
      weatherTemp: (map['weatherTemp'] as num?)?.toDouble() ?? 29.0,
      irrigationStatus: map['irrigationStatus'] ?? 'Scheduled',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 21.1458,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 79.0882,
    );
  }

  FarmModel copyWith({
    double? healthScore,
    double? diseaseRisk,
    double? pestRisk,
    String? irrigationStatus,
    double? weatherTemp,
  }) {
    return FarmModel(
      id: id,
      ownerId: ownerId,
      name: name,
      location: location,
      areaAcres: areaAcres,
      orangeVariety: orangeVariety,
      numberOfTrees: numberOfTrees,
      treeAgeYears: treeAgeYears,
      soilType: soilType,
      irrigationType: irrigationType,
      healthScore: healthScore ?? this.healthScore,
      diseaseRisk: diseaseRisk ?? this.diseaseRisk,
      pestRisk: pestRisk ?? this.pestRisk,
      soilCondition: soilCondition,
      weatherTemp: weatherTemp ?? this.weatherTemp,
      irrigationStatus: irrigationStatus ?? this.irrigationStatus,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
