class YieldPredictionResult {
  final double estimatedYieldTonnes;
  final double minRangeTonnes;
  final double maxRangeTonnes;
  final String estimatedHarvestWindow;
  final double averageYieldPerTreeKg;
  final double revenueProjectionInr;
  final List<String> contributingFactors;

  YieldPredictionResult({
    required this.estimatedYieldTonnes,
    required this.minRangeTonnes,
    required this.maxRangeTonnes,
    required this.estimatedHarvestWindow,
    required this.averageYieldPerTreeKg,
    required this.revenueProjectionInr,
    required this.contributingFactors,
  });
}

abstract class YieldPredictionService {
  YieldPredictionResult calculateYield({
    required int numberOfTrees,
    required int treeAgeYears,
    required double cropHealthScore,
    required double diseaseRisk,
  });
}

class MockYieldPredictionService implements YieldPredictionService {
  @override
  YieldPredictionResult calculateYield({
    required int numberOfTrees,
    required int treeAgeYears,
    required double cropHealthScore,
    required double diseaseRisk,
  }) {
    // Mature Nagpur mandarin tree typically yields 55-80 kg at age 6-8
    double baseYieldPerTree = 6.8; // kg baseline
    if (treeAgeYears >= 5) {
      baseYieldPerTree = 6.8 + (treeAgeYears * 0.45);
    }

    // Health factor impact
    double healthMultiplier = (cropHealthScore / 100.0) * (1.0 - (diseaseRisk / 250.0));
    double finalYieldPerTree = baseYieldPerTree * healthMultiplier;
    double totalTonnes = (numberOfTrees * finalYieldPerTree) / 1000.0;

    // Fixed realistic baseline matching requested specification: 8.4 tonnes (7.8 - 9.1)
    double targetTonnes = totalTonnes > 0 ? (totalTonnes * 1.05) : 8.4;
    double minTonnes = double.parse((targetTonnes * 0.93).toStringAsFixed(1));
    double maxTonnes = double.parse((targetTonnes * 1.08).toStringAsFixed(1));
    double avgTonnes = double.parse(targetTonnes.toStringAsFixed(1));

    return YieldPredictionResult(
      estimatedYieldTonnes: avgTonnes,
      minRangeTonnes: minTonnes,
      maxRangeTonnes: maxTonnes,
      estimatedHarvestWindow: 'December 10 – January 05',
      averageYieldPerTreeKg: double.parse((avgTonnes * 1000 / numberOfTrees).toStringAsFixed(1)),
      revenueProjectionInr: avgTonnes * 42000.0, // Avg Mandi rate ₹42/kg
      contributingFactors: [
        'Tree density of $numberOfTrees mature orange trees',
        'Canopy vigor index standing at ${cropHealthScore.toInt()}%',
        'Favorable chilling hours and blossoming flush observed in spring',
        'Minimal fruit drop due to optimized automated drip cycles',
      ],
    );
  }
}
