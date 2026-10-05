class HarvestBatchModel {
  final String id;
  final String batchCode; // e.g. "OR-2026-001"
  final String farmId;
  final String farmName;
  final String harvestDate;
  final double quantityKg;
  final String qualityGrade; // "Grade A+", "Grade A", "Grade B"
  final String status; // "Packaged", "In Transit", "Dispatched", "Quality Certified"
  final bool aiMonitored;
  final double sugarBrix;
  final double averageWeightGram;
  final String traceabilityNotes;

  HarvestBatchModel({
    required this.id,
    required this.batchCode,
    required this.farmId,
    required this.farmName,
    required this.harvestDate,
    required this.quantityKg,
    required this.qualityGrade,
    required this.status,
    this.aiMonitored = true,
    this.sugarBrix = 11.8,
    this.averageWeightGram = 185.0,
    this.traceabilityNotes = 'Continuous sensor monitoring, zero synthetic pesticide residues in last 45 days.',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'batchCode': batchCode,
      'farmId': farmId,
      'farmName': farmName,
      'harvestDate': harvestDate,
      'quantityKg': quantityKg,
      'qualityGrade': qualityGrade,
      'status': status,
      'aiMonitored': aiMonitored,
      'sugarBrix': sugarBrix,
      'averageWeightGram': averageWeightGram,
      'traceabilityNotes': traceabilityNotes,
    };
  }

  factory HarvestBatchModel.fromMap(Map<String, dynamic> map) {
    return HarvestBatchModel(
      id: map['id'] ?? '',
      batchCode: map['batchCode'] ?? 'OR-2026-001',
      farmId: map['farmId'] ?? '',
      farmName: map['farmName'] ?? 'Green Valley Orange Farm',
      harvestDate: map['harvestDate'] ?? '04 Oct 2026',
      quantityKg: (map['quantityKg'] as num?)?.toDouble() ?? 2450.0,
      qualityGrade: map['qualityGrade'] ?? 'Grade A+',
      status: map['status'] ?? 'Quality Certified',
      aiMonitored: map['aiMonitored'] ?? true,
      sugarBrix: (map['sugarBrix'] as num?)?.toDouble() ?? 11.8,
      averageWeightGram: (map['averageWeightGram'] as num?)?.toDouble() ?? 185.0,
      traceabilityNotes: map['traceabilityNotes'] ?? '',
    );
  }
}
