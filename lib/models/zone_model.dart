import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class ZoneModel {
  final String id;
  final String farmId;
  final String name;
  final int numberOfTrees;
  final double healthScore;
  final int diseaseCases;
  final String pestRisk; // 'LOW', 'MEDIUM', 'HIGH'
  final double soilMoisture; // %
  final String lastInspectionDate;
  final String statusColor; // 'GREEN', 'YELLOW', 'ORANGE', 'RED'
  final String description;
  final double centerLat;
  final double centerLng;

  ZoneModel({
    required this.id,
    required this.farmId,
    required this.name,
    required this.numberOfTrees,
    required this.healthScore,
    required this.diseaseCases,
    required this.pestRisk,
    required this.soilMoisture,
    required this.lastInspectionDate,
    required this.statusColor,
    this.description = 'Active production block',
    this.centerLat = 21.1458,
    this.centerLng = 79.0882,
  });

  Color get displayColor {
    switch (statusColor.toUpperCase()) {
      case 'GREEN':
        return AppColors.healthyGreen;
      case 'YELLOW':
        return AppColors.moderateYellow;
      case 'ORANGE':
        return AppColors.inspectionOrange;
      case 'RED':
        return AppColors.diseasedRed;
      default:
        return AppColors.healthyGreen;
    }
  }

  String get statusLabel {
    switch (statusColor.toUpperCase()) {
      case 'GREEN':
        return 'Healthy';
      case 'YELLOW':
        return 'Moderate Risk';
      case 'ORANGE':
        return 'Needs Inspection';
      case 'RED':
        return 'Diseased';
      default:
        return 'Normal';
    }
  }

  ZoneModel copyWith({
    double? healthScore,
    int? diseaseCases,
    String? pestRisk,
    double? soilMoisture,
    String? lastInspectionDate,
    String? statusColor,
  }) {
    return ZoneModel(
      id: id,
      farmId: farmId,
      name: name,
      numberOfTrees: numberOfTrees,
      healthScore: healthScore ?? this.healthScore,
      diseaseCases: diseaseCases ?? this.diseaseCases,
      pestRisk: pestRisk ?? this.pestRisk,
      soilMoisture: soilMoisture ?? this.soilMoisture,
      lastInspectionDate: lastInspectionDate ?? this.lastInspectionDate,
      statusColor: statusColor ?? this.statusColor,
      description: description,
      centerLat: centerLat,
      centerLng: centerLng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmId': farmId,
      'name': name,
      'numberOfTrees': numberOfTrees,
      'healthScore': healthScore,
      'diseaseCases': diseaseCases,
      'pestRisk': pestRisk,
      'soilMoisture': soilMoisture,
      'lastInspectionDate': lastInspectionDate,
      'statusColor': statusColor,
      'description': description,
      'centerLat': centerLat,
      'centerLng': centerLng,
    };
  }

  factory ZoneModel.fromMap(Map<String, dynamic> map) {
    return ZoneModel(
      id: map['id'] ?? '',
      farmId: map['farmId'] ?? '',
      name: map['name'] ?? '',
      numberOfTrees: (map['numberOfTrees'] as num?)?.toInt() ?? 300,
      healthScore: (map['healthScore'] as num?)?.toDouble() ?? 85.0,
      diseaseCases: (map['diseaseCases'] as num?)?.toInt() ?? 0,
      pestRisk: map['pestRisk'] ?? 'LOW',
      soilMoisture: (map['soilMoisture'] as num?)?.toDouble() ?? 60.0,
      lastInspectionDate: map['lastInspectionDate'] ?? '02 Oct 2026',
      statusColor: map['statusColor'] ?? 'GREEN',
      description: map['description'] ?? '',
      centerLat: (map['centerLat'] as num?)?.toDouble() ?? 21.1458,
      centerLng: (map['centerLng'] as num?)?.toDouble() ?? 79.0882,
    );
  }
}
