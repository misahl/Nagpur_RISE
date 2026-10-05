class TreeModel {
  final String id;
  final String farmId;
  final String zoneId;
  final String treeCode; // e.g. "Tree B-042"
  final int ageYears;
  final String variety;
  final double healthScore;
  final String currentStatus; // "Healthy", "Needs Inspection", "Diseased"
  final int diseaseHistoryCount;
  final String lastInspection;
  final String notes;
  final double latitude;
  final double longitude;

  TreeModel({
    required this.id,
    required this.farmId,
    required this.zoneId,
    required this.treeCode,
    required this.ageYears,
    required this.variety,
    required this.healthScore,
    required this.currentStatus,
    required this.diseaseHistoryCount,
    required this.lastInspection,
    this.notes = 'Regular growth cycle',
    this.latitude = 21.1460,
    this.longitude = 79.0885,
  });

  TreeModel copyWith({
    double? healthScore,
    String? currentStatus,
    int? diseaseHistoryCount,
    String? lastInspection,
    String? notes,
  }) {
    return TreeModel(
      id: id,
      farmId: farmId,
      zoneId: zoneId,
      treeCode: treeCode,
      ageYears: ageYears,
      variety: variety,
      healthScore: healthScore ?? this.healthScore,
      currentStatus: currentStatus ?? this.currentStatus,
      diseaseHistoryCount: diseaseHistoryCount ?? this.diseaseHistoryCount,
      lastInspection: lastInspection ?? this.lastInspection,
      notes: notes ?? this.notes,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmId': farmId,
      'zoneId': zoneId,
      'treeCode': treeCode,
      'ageYears': ageYears,
      'variety': variety,
      'healthScore': healthScore,
      'currentStatus': currentStatus,
      'diseaseHistoryCount': diseaseHistoryCount,
      'lastInspection': lastInspection,
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory TreeModel.fromMap(Map<String, dynamic> map) {
    return TreeModel(
      id: map['id'] ?? '',
      farmId: map['farmId'] ?? '',
      zoneId: map['zoneId'] ?? '',
      treeCode: map['treeCode'] ?? '',
      ageYears: (map['ageYears'] as num?)?.toInt() ?? 5,
      variety: map['variety'] ?? 'Nagpur Mandarin',
      healthScore: (map['healthScore'] as num?)?.toDouble() ?? 80.0,
      currentStatus: map['currentStatus'] ?? 'Healthy',
      diseaseHistoryCount: (map['diseaseHistoryCount'] as num?)?.toInt() ?? 0,
      lastInspection: map['lastInspection'] ?? '03 Oct 2026',
      notes: map['notes'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 21.1460,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 79.0885,
    );
  }
}
