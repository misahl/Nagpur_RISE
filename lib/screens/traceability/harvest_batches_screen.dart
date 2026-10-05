import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/harvest_batch_model.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';
import 'qr_view_screen.dart';

class HarvestBatchesScreen extends StatefulWidget {
  const HarvestBatchesScreen({super.key});

  @override
  State<HarvestBatchesScreen> createState() => _HarvestBatchesScreenState();
}

class _HarvestBatchesScreenState extends State<HarvestBatchesScreen> {
  void _openAddBatchDialog() {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController(text: 'OR-2026-00${DateTime.now().millisecond % 9 + 3}');
    final qtyController = TextEditingController(text: '2200');
    String grade = 'Grade A+ (Premium Export)';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Create New Orange Harvest Batch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(labelText: 'Batch Tracking Code'),
                    validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Harvested Quantity (Kg)'),
                    validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: grade,
                    decoration: const InputDecoration(labelText: 'Quality Grade'),
                    items: [
                      'Grade A+ (Premium Export)',
                      'Grade A (Table Market)',
                      'Grade B (Juice Processing)',
                    ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (val) => grade = val ?? grade,
                  ),
                  const SizedBox(height: 18),

                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final farmState = Provider.of<FarmStateProvider>(context, listen: false);
                        final newBatch = HarvestBatchModel(
                          id: 'batch_${DateTime.now().millisecondsSinceEpoch}',
                          batchCode: codeController.text.trim(),
                          farmId: farmState.currentFarm.id,
                          farmName: farmState.currentFarm.name,
                          harvestDate: 'Today, Oct 2026',
                          quantityKg: double.tryParse(qtyController.text.trim()) ?? 2000.0,
                          qualityGrade: grade,
                          status: 'Packaged & Certified',
                        );
                        farmState.addHarvestBatch(newBatch);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Batch ${newBatch.batchCode} registered with QR Code!')),
                        );
                      }
                    },
                    child: const Text('Generate Batch & QR Code'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orange Value Chain Batches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: AppColors.primaryOrange),
            tooltip: 'New Harvest Batch',
            onPressed: _openAddBatchDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddBatchDialog,
        backgroundColor: AppColors.primaryOrange,
        icon: const Icon(Icons.qr_code_2),
        label: const Text('New Batch'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Traceability Info Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryOrange, AppColors.orangeDark],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: Colors.white, size: 32),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Farm-to-Consumer QR Traceability',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Every orange crate carries a cryptographically verifiable QR code linking to AI health monitoring & harvest dates.',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Registered Orange Batches',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),

            ...farmState.harvestBatches.map((batch) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.orangeSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryOrange.withAlpha(80)),
                        ),
                        child: const Icon(Icons.qr_code_2, color: AppColors.primaryOrange, size: 36),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(batch.batchCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.greenSurface,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    batch.qualityGrade.split(' ').first,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${batch.quantityKg.toInt()} Kg • Brix: ${batch.sugarBrix}° • ${batch.harvestDate}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Status: ${batch.status}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryOrange),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textMuted),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => QrViewScreen(batch: batch)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
