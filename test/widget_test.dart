import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orange_ai/models/farm_model.dart';
import 'package:orange_ai/models/zone_model.dart';
import 'package:orange_ai/services/ai_service.dart';
import 'package:orange_ai/widgets/health_card.dart';
import 'package:orange_ai/widgets/metric_card.dart';

void main() {
  test('FarmModel and ZoneModel initialization test', () {
    final farm = FarmModel(
      id: 'farm_01',
      ownerId: 'farmer_01',
      name: 'Green Valley Orange Farm',
      location: 'Kalmeshwar, Nagpur',
      areaAcres: 4.2,
      orangeVariety: 'Nagpur Mandarin',
      numberOfTrees: 1240,
      treeAgeYears: 6,
      soilType: 'Black Soil',
      irrigationType: 'Drip System',
    );

    expect(farm.name, 'Green Valley Orange Farm');
    expect(farm.numberOfTrees, 1240);
    expect(farm.areaAcres, 4.2);

    final zone = ZoneModel(
      id: 'zone_b',
      farmId: 'farm_01',
      name: 'Zone B',
      numberOfTrees: 320,
      healthScore: 72.0,
      diseaseCases: 2,
      pestRisk: 'MEDIUM',
      soilMoisture: 24.0,
      lastInspectionDate: '04 Oct 2026',
      statusColor: 'YELLOW',
    );

    expect(zone.statusLabel, 'Moderate Risk');
    expect(zone.soilMoisture, 24.0);
  });

  test('AIService Citrus Canker diagnostic test', () async {
    final aiService = MockAIService();
    final result = await aiService.analyzeLeafImage(
      imageFile: 'assets/images/canker_leaf.jpg',
      farmId: 'farm_01',
      zoneId: 'zone_b',
      zoneName: 'Zone B',
      treeId: 'tree_b_042',
      treeCode: 'Tree B-042',
      forcedDisease: 'Citrus Canker',
    );

    expect(result.diseaseName, 'Citrus Canker');
    expect(result.confidence, 0.94);
    expect(result.severity, 'High');
    expect(result.visualIndicators.isNotEmpty, true);
  });

  testWidgets('HealthCard and MetricCard widget rendering test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              HealthCard(
                overallHealth: 87.0,
                diseaseRisk: 12.0,
                pestRisk: 8.0,
                soilMoisture: 64.0,
              ),
              MetricCard(
                title: 'Soil Moisture',
                value: '64%',
                icon: Icons.water_drop,
                iconColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Crop Health Score'), findsOneWidget);
    expect(find.text('87%'), findsOneWidget);
    expect(find.text('Disease Risk'), findsOneWidget);
    expect(find.text('Soil Moisture'), findsNWidgets(2));
  });
}
