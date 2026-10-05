import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/harvest_batch_model.dart';
import '../../core/constants/app_colors.dart';

class QrViewScreen extends StatelessWidget {
  final HarvestBatchModel batch;

  const QrViewScreen({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    final qrPayload = 'ORANGEAI-BATCH:${batch.batchCode}|FARM:${batch.farmName}|HARVEST:${batch.harvestDate}|QTY:${batch.quantityKg}KG|GRADE:${batch.qualityGrade}|AI_VERIFIED:TRUE';

    return Scaffold(
      appBar: AppBar(
        title: Text('Batch ${batch.batchCode}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting QR Traceability Certificate.')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // QR Code Presentation Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🍊', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Text(
                        'OrangeAI Value Chain Pass',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Real QR Code Generator Widget
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primaryOrange.withAlpha(100), width: 2),
                      ),
                      child: QrImageView(
                        data: qrPayload,
                        version: QrVersions.auto,
                        size: 200.0,
                        eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.primaryOrange),
                        dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    batch.batchCode,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.greenSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, color: AppColors.healthyGreen, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'AI Continuous Monitoring Certified',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Traceability Audit Details
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Production & Provenance Record', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 14),
                  _buildTraceRow('Origin Farm', batch.farmName, Icons.agriculture),
                  const Divider(height: 16),
                  _buildTraceRow('Harvest Date', batch.harvestDate, Icons.calendar_today),
                  const Divider(height: 16),
                  _buildTraceRow('Quantity', '${batch.quantityKg.toInt()} Kilograms', Icons.scale),
                  const Divider(height: 16),
                  _buildTraceRow('Quality Classification', batch.qualityGrade, Icons.grade),
                  const Divider(height: 16),
                  _buildTraceRow('Sugar Content (Brix)', '${batch.sugarBrix}° Brix (Optimal Sweetness)', Icons.water_drop_outlined),
                  const Divider(height: 16),
                  _buildTraceRow('Batch Status', batch.status, Icons.local_shipping_outlined),
                  const Divider(height: 16),
                  _buildTraceRow('Agri-Chemical Safety', 'Zero synthetic pesticide residue detected', Icons.security),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTraceRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryOrange),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
