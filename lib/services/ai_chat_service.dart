import '../models/farm_model.dart';
import '../models/zone_model.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

abstract class AIChatService {
  Future<String> getResponse({
    required String query,
    required FarmModel farm,
    required List<ZoneModel> zones,
    required double soilMoisture,
    required int rainProbability,
  });
}

class ContextualFarmChatService implements AIChatService {
  @override
  Future<String> getResponse({
    required String query,
    required FarmModel farm,
    required List<ZoneModel> zones,
    required double soilMoisture,
    required int rainProbability,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final q = query.toLowerCase();

    if (q.contains('how is my farm') || q.contains('overall') || q.contains('health')) {
      return 'Your farm "${farm.name}" is currently at ${farm.healthScore.toInt()}% Overall Health with an estimated disease risk of ${farm.diseaseRisk.toInt()}%. Canopy vigor is strong across ${farm.numberOfTrees} trees.';
    }

    if (q.contains('which zone') || q.contains('attention') || q.contains('problem')) {
      final highRisk = zones.where((z) => z.statusColor == 'ORANGE' || z.statusColor == 'RED').toList();
      if (highRisk.isNotEmpty) {
        return 'Zone B and Zone C require immediate attention. Zone B has low soil moisture and recent Citrus Canker lesions flagged. Field inspection is recommended.';
      }
      return 'All zones are currently stable. Zone B has the lowest moisture level and should be monitored closely.';
    }

    if (q.contains('irrigate') || q.contains('water') || q.contains('pump')) {
      if (rainProbability > 40) {
        return 'Rain is expected in 3 hours ($rainProbability% probability). Drip irrigation is NOT recommended today to prevent waterlogging and collar rot.';
      }
      return 'Zone B soil moisture is low ($soilMoisture%). A 45-minute drip cycle is recommended today.';
    }

    if (q.contains('highest disease risk') || q.contains('disease') || q.contains('canker')) {
      return 'Zone C currently displays the highest disease risk index (72% HIGH) due to high local micro-humidity and prior fungal spore detection. Zone B also has active canker scans.';
    }

    if (q.contains('inspect') || q.contains('when') || q.contains('schedule')) {
      return 'You should perform a field walk in Zone B today before 5:00 PM. A worker task has already been scheduled for Tree B-042 inspection.';
    }

    return 'Based on real-time sensors across your 4.2 acres: Soil moisture is ${soilMoisture.toInt()}%, temperature is 29°C, and weather is favorable. Feel free to ask about irrigation, disease risk, or yield forecasts!';
  }
}
