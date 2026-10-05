class DiseaseScanModel {
  final String id;
  final String farmId;
  final String zoneId;
  final String zoneName;
  final String treeId;
  final String treeCode;
  final String imageUrl;
  final String diseaseName;
  final double confidence; // e.g. 0.94 (94%)
  final String severity; // Low, Medium, High, Critical
  final List<String> visualIndicators;
  final String recommendedAction;
  final DateTime timestamp;
  final String notes;

  DiseaseScanModel({
    required this.id,
    required this.farmId,
    required this.zoneId,
    required this.zoneName,
    required this.treeId,
    required this.treeCode,
    required this.imageUrl,
    required this.diseaseName,
    required this.confidence,
    required this.severity,
    required this.visualIndicators,
    required this.recommendedAction,
    required this.timestamp,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmId': farmId,
      'zoneId': zoneId,
      'zoneName': zoneName,
      'treeId': treeId,
      'treeCode': treeCode,
      'imageUrl': imageUrl,
      'diseaseName': diseaseName,
      'confidence': confidence,
      'severity': severity,
      'visualIndicators': visualIndicators,
      'recommendedAction': recommendedAction,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  factory DiseaseScanModel.fromMap(Map<String, dynamic> map) {
    return DiseaseScanModel(
      id: map['id'] ?? '',
      farmId: map['farmId'] ?? '',
      zoneId: map['zoneId'] ?? '',
      zoneName: map['zoneName'] ?? 'Zone B',
      treeId: map['treeId'] ?? '',
      treeCode: map['treeCode'] ?? 'Tree B-042',
      imageUrl: map['imageUrl'] ?? '',
      diseaseName: map['diseaseName'] ?? 'Healthy',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.95,
      severity: map['severity'] ?? 'Low',
      visualIndicators: List<String>.from(map['visualIndicators'] ?? []),
      recommendedAction: map['recommendedAction'] ?? 'Continue regular maintenance',
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
      notes: map['notes'] ?? '',
    );
  }
}
