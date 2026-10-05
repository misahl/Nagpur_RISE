import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AlertModel {
  final String id;
  final String farmId;
  final String title;
  final String message;
  final String type; // 'Disease', 'Pest', 'Water', 'Weather', 'Drone', 'Harvest', 'Sensor'
  final String severity; // 'Low', 'Medium', 'High', 'Critical'
  final DateTime timestamp;
  final bool isRead;
  final String? relatedZone;

  AlertModel({
    required this.id,
    required this.farmId,
    required this.title,
    required this.message,
    required this.type,
    required this.severity,
    required this.timestamp,
    this.isRead = false,
    this.relatedZone,
  });

  IconData get icon {
    switch (type.toLowerCase()) {
      case 'disease':
        return Icons.coronavirus_outlined;
      case 'pest':
        return Icons.pest_control_outlined;
      case 'water':
        return Icons.water_drop_outlined;
      case 'weather':
        return Icons.cloud_outlined;
      case 'drone':
        return Icons.flight_takeoff_outlined;
      case 'harvest':
        return Icons.agriculture_outlined;
      case 'sensor':
        return Icons.sensors_outlined;
      default:
        return Icons.notifications_active_outlined;
    }
  }

  Color get color {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'high':
        return AppColors.diseasedRed;
      case 'medium':
        return AppColors.moderateYellow;
      case 'low':
      default:
        return AppColors.primaryOrange;
    }
  }

  AlertModel copyWith({bool? isRead}) {
    return AlertModel(
      id: id,
      farmId: farmId,
      title: title,
      message: message,
      type: type,
      severity: severity,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      relatedZone: relatedZone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmId': farmId,
      'title': title,
      'message': message,
      'type': type,
      'severity': severity,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'relatedZone': relatedZone,
    };
  }

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      id: map['id'] ?? '',
      farmId: map['farmId'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'Disease',
      severity: map['severity'] ?? 'Medium',
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
      relatedZone: map['relatedZone'],
    );
  }
}
