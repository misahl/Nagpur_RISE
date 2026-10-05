import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/farm_state_provider.dart';
import '../../services/fruit_detection_service.dart';
import '../../core/constants/app_colors.dart';

class FruitDetectionScreen extends StatefulWidget {
  const FruitDetectionScreen({super.key});

  @override
  State<FruitDetectionScreen> createState() => _FruitDetectionScreenState();
}

class _FruitDetectionScreenState extends State<FruitDetectionScreen> {
  bool _isAnalyzing = false;
  FruitAnalysisResult? _result;

  void _analyzeCluster() async {
    setState(() => _isAnalyzing = true);
    final farmState = Provider.of<FarmStateProvider>(context, listen: false);

    final res = await farmState.fruitService.analyzeBranchImage('assets/images/fruit_cluster.jpg');
    setState(() {
      _result = res;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Fruit & Yield Vision'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sample image preview
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('assets/images/fruit_cluster.jpg', fit: BoxFit.cover),
                    if (_isAnalyzing)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(color: AppColors.primaryOrange),
                              SizedBox(height: 12),
                              Text(
                                'YOLO Vision Model Counting Fruits...',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            if (_result == null)
              ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _analyzeCluster,
                icon: const Icon(Icons.search),
                label: const Text('Detect & Classify Fruits (YOLO Vision)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              )
            else ...[
              // Results Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cluster Analysis Result', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('YOLOv8 Citrus Model', style: TextStyle(fontSize: 11, color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Metrics Grid (Detected: 37, Healthy: 32, Damaged: 5, Mature: 21, Immature: 16)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 2.2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        _buildTile('Detected Fruits', '${_result!.totalCount}', AppColors.primaryOrange),
                        _buildTile('Healthy Oranges', '${_result!.healthyCount}', AppColors.healthyGreen),
                        _buildTile('Damaged / Scratched', '${_result!.damagedCount}', AppColors.diseasedRed),
                        _buildTile('Mature (Harvestable)', '${_result!.matureCount}', Colors.amber.shade800),
                        _buildTile('Immature (Green)', '${_result!.immatureCount}', Colors.teal),
                        _buildTile('Avg Caliber Size', '${_result!.averageDiameterMm} mm', Colors.indigo),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Observations list
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.greenSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.healthyGreen.withAlpha(80)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Agronomic Maturity Insights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.greenDark)),
                    const SizedBox(height: 10),
                    ..._result!.observations.map((obs) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline, size: 16, color: AppColors.healthyGreen),
                            const SizedBox(width: 8),
                            Expanded(child: Text(obs, style: const TextStyle(fontSize: 12, height: 1.3))),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: _analyzeCluster,
                icon: const Icon(Icons.refresh),
                label: const Text('Re-run Vision Scan'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
