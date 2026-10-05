class PestReportModel {
  final String id;
  final String farmId;
  final String zoneId;
  final String zoneName;
  final String pestType;
  final String severity; // 'LOW', 'MEDIUM', 'HIGH'
  final String photoUrl;
  final DateTime date;
  final String notes;
  final String trapCount;

  PestReportModel({
    required this.id,
    required this.farmId,
    required this.zoneId,
    required this.zoneName,
    required this.pestType,
    required this.severity,
    required this.photoUrl,
    required this.date,
    required this.notes,
    this.trapCount = '4 traps checked',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmId': farmId,
      'zoneId': zoneId,
      'zoneName': zoneName,
      'pestType': pestType,
      'severity': severity,
      'photoUrl': photoUrl,
      'date': date.toIso8601String(),
      'notes': notes,
      'trapCount': trapCount,
    };
  }

  factory PestReportModel.fromMap(Map<String, dynamic> map) {
    return PestReportModel(
      id: map['id'] ?? '',
      farmId: map['farmId'] ?? '',
      zoneId: map['zoneId'] ?? '',
      zoneName: map['zoneName'] ?? 'Zone B',
      pestType: map['pestType'] ?? 'Citrus Leafminer',
      severity: map['severity'] ?? 'MEDIUM',
      photoUrl: map['photoUrl'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      notes: map['notes'] ?? '',
      trapCount: map['trapCount'] ?? '4 traps checked',
    );
  }
}
