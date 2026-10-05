import '../models/farm_model.dart';
import '../models/zone_model.dart';
import '../models/disease_scan_model.dart';

class FarmReportData {
  final String reportId;
  final String generatedDate;
  final FarmModel farm;
  final List<ZoneModel> zones;
  final List<DiseaseScanModel> recentScans;
  final double cropHealth;
  final double leafHealth;
  final double soilHealth;
  final double waterStatus;
  final double diseaseRisk;
  final double pestRisk;
  final String weatherSummary;
  final double totalWaterUsedLiters;
  final String yieldPredictionText;
  final List<String> recommendations;

  FarmReportData({
    required this.reportId,
    required this.generatedDate,
    required this.farm,
    required this.zones,
    required this.recentScans,
    required this.cropHealth,
    required this.leafHealth,
    required this.soilHealth,
    required this.waterStatus,
    required this.diseaseRisk,
    required this.pestRisk,
    required this.weatherSummary,
    required this.totalWaterUsedLiters,
    required this.yieldPredictionText,
    required this.recommendations,
  });
}

class ReportService {
  FarmReportData generateReport({
    required FarmModel farm,
    required List<ZoneModel> zones,
    required List<DiseaseScanModel> recentScans,
    required double totalWaterLiters,
  }) {
    return FarmReportData(
      reportId: 'REP-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      generatedDate: '05 Oct 2026, 17:30 IST',
      farm: farm,
      zones: zones,
      recentScans: recentScans,
      cropHealth: farm.healthScore,
      leafHealth: 92.0,
      soilHealth: 81.0,
      waterStatus: 76.0,
      diseaseRisk: farm.diseaseRisk,
      pestRisk: farm.pestRisk,
      weatherSummary: '29°C Partly Cloudy, 20% Rain Probability, Wind 14 km/h',
      totalWaterUsedLiters: totalWaterLiters,
      yieldPredictionText: '8.4 tonnes (Range: 7.8 – 9.1 tonnes) • Harvest: Dec 10 – Jan 05',
      recommendations: [
        'Perform preventive Copper Oxychloride application in Zone B following Citrus Canker detection.',
        'Regulate drip emitters in Zone B to restore optimal root-zone moisture above 50%.',
        'Deploy yellow sticky pheromone traps for early citrus leafminer and aphid suppression.',
        'Review autonomous drone multi-spectral scans weekly during pre-harvest fruit sizing.',
      ],
    );
  }
}
