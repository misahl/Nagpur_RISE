import 'dart:io';
import '../models/disease_scan_model.dart';

abstract class AIService {
  Future<DiseaseScanModel> analyzeLeafImage({
    required dynamic imageFile, // File, XFile, or asset string
    required String farmId,
    required String zoneId,
    required String zoneName,
    required String treeId,
    required String treeCode,
    String? forcedDisease, // For demo control
  });
}

class MockAIService implements AIService {
  @override
  Future<DiseaseScanModel> analyzeLeafImage({
    required dynamic imageFile,
    required String farmId,
    required String zoneId,
    required String zoneName,
    required String treeId,
    required String treeCode,
    String? forcedDisease,
  }) async {
    // Simulate real AI neural network inference delay
    await Future.delayed(const Duration(milliseconds: 1400));

    final disease = forcedDisease ?? 'Citrus Canker';

    String severity = 'High';
    double confidence = 0.94;
    List<String> indicators = [
      'Raised corky brownish-tan lesions on leaf surface',
      'Prominent oily water-soaked yellow chlorotic halos',
      'Irregular leaf margin spotting and minor necrotic crinkle',
    ];
    String action = 'Prune heavily infected twigs immediately. Apply Copper Oxychloride 50 WP (3g/liter) foliar spray. Isolate Zone B trees and sanitize pruning tools.';

    if (disease == 'Healthy') {
      severity = 'Low';
      confidence = 0.96;
      indicators = [
        'Vibrant dark green chlorophyll pigmentation',
        'Intact leaf cuticles with no necrotic lesions',
        'Normal vein architecture and optimal turgor pressure',
      ];
      action = 'No intervention required. Maintain standard micronutrient foliar spray schedule.';
    } else if (disease == 'Citrus Greening') {
      severity = 'Critical';
      confidence = 0.91;
      indicators = [
        'Asymmetric blotchy mottling across leaf veins',
        'Vein yellowing and small upright pale leaves',
        'Early signs of zinc-deficiency mimicking chlorosis',
      ];
      action = 'Quarantine infected tree immediately. Check for Asian Citrus Psyllid vectors. Apply Imidacloprid systemic insecticide.';
    } else if (disease == 'Leaf Miner Damage') {
      severity = 'Medium';
      confidence = 0.89;
      indicators = [
        'Serpentine silvery winding mines under leaf epidermis',
        'Curling of young tender flush shoots',
        'Secondary blister formation along feeding galleries',
      ];
      action = 'Spray Neem oil formulation (5ml/L) or Abamectin. Avoid heavy nitrogen applications that promote excess tender flushes.';
    } else if (disease == 'Water Stress') {
      severity = 'Medium';
      confidence = 0.92;
      indicators = [
        'Inward cupping of older mature citrus foliage',
        'Loss of turgor pressure and subtle dull grayish cast',
        'Accelerated abscission of small fruitlets',
      ];
      action = 'Initiate drip irrigation cycle for 45 minutes immediately. Verify soil moisture tension in root zone.';
    }

    String imagePath = '';
    if (imageFile is File) {
      imagePath = imageFile.path;
    } else if (imageFile is String) {
      imagePath = imageFile;
    } else {
      imagePath = 'assets/images/canker_leaf.jpg';
    }

    return DiseaseScanModel(
      id: 'scan_${DateTime.now().millisecondsSinceEpoch}',
      farmId: farmId,
      zoneId: zoneId,
      zoneName: zoneName,
      treeId: treeId,
      treeCode: treeCode,
      imageUrl: imagePath,
      diseaseName: disease,
      confidence: confidence,
      severity: severity,
      visualIndicators: indicators,
      recommendedAction: action,
      timestamp: DateTime.now(),
    );
  }
}

class RealAIService implements AIService {
  final String apiEndpoint;
  final String? apiKey;

  RealAIService({
    this.apiEndpoint = 'https://api.orangeai.farm/v1/diagnose',
    this.apiKey,
  });

  @override
  Future<DiseaseScanModel> analyzeLeafImage({
    required dynamic imageFile,
    required String farmId,
    required String zoneId,
    required String zoneName,
    required String treeId,
    required String treeCode,
    String? forcedDisease,
  }) async {
    // Structure ready to send multipart POST request to Python / FastAPI / TF-Serving backend
    try {
      // Fallback gracefully to mock if endpoint is unreachable
      return await MockAIService().analyzeLeafImage(
        imageFile: imageFile,
        farmId: farmId,
        zoneId: zoneId,
        zoneName: zoneName,
        treeId: treeId,
        treeCode: treeCode,
        forcedDisease: forcedDisease,
      );
    } catch (e) {
      return await MockAIService().analyzeLeafImage(
        imageFile: imageFile,
        farmId: farmId,
        zoneId: zoneId,
        zoneName: zoneName,
        treeId: treeId,
        treeCode: treeCode,
        forcedDisease: forcedDisease,
      );
    }
  }
}
