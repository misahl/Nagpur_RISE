import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/pest_report_model.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';

class PestMonitoringScreen extends StatefulWidget {
  const PestMonitoringScreen({super.key});

  @override
  State<PestMonitoringScreen> createState() => _PestMonitoringScreenState();
}

class _PestMonitoringScreenState extends State<PestMonitoringScreen> {
  void _openAddPestDialog() {
    final formKey = GlobalKey<FormState>();
    String pestType = 'Citrus Leafminer (Phyllocnistis citrella)';
    String zoneName = 'Zone B';
    String severity = 'MEDIUM';
    final notesController = TextEditingController(text: 'Visual serpentine mines on 4 trees in row 3.');

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
                  const Text('Record Pest Trap Observation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    value: pestType,
                    decoration: const InputDecoration(labelText: 'Pest Type'),
                    items: [
                      'Citrus Leafminer (Phyllocnistis citrella)',
                      'Asian Citrus Psyllid (Diaphorina citri)',
                      'Citrus Whitefly (Aleurocanthus woglumi)',
                      'Fruit Sucking Moth (Eudocima materna)',
                      'Citrus Thrips (Scirtothrips citri)',
                    ].map((p) => DropdownMenuItem(value: p, child: Text(p, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (val) => pestType = val ?? pestType,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: zoneName,
                          decoration: const InputDecoration(labelText: 'Affected Zone'),
                          items: ['Zone A', 'Zone B', 'Zone C', 'Zone D'].map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
                          onChanged: (val) => zoneName = val ?? zoneName,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: severity,
                          decoration: const InputDecoration(labelText: 'Severity'),
                          items: ['LOW', 'MEDIUM', 'HIGH'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                          onChanged: (val) => severity = val ?? severity,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Trap Count / Field Notes'),
                  ),
                  const SizedBox(height: 18),

                  ElevatedButton(
                    onPressed: () {
                      final farmState = Provider.of<FarmStateProvider>(context, listen: false);
                      farmState.addPestReport(
                        PestReportModel(
                          id: 'pest_${DateTime.now().millisecondsSinceEpoch}',
                          farmId: farmState.currentFarm.id,
                          zoneId: zoneName.toLowerCase().replaceAll(' ', '_'),
                          zoneName: zoneName,
                          pestType: pestType,
                          severity: severity,
                          photoUrl: '',
                          date: DateTime.now(),
                          notes: notesController.text.trim(),
                        ),
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pest observation logged successfully!')),
                      );
                    },
                    child: const Text('Save Pest Observation'),
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
        title: const Text('Pest Pressure & Traps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryOrange),
            tooltip: 'Log Pest Report',
            onPressed: _openAddPestDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddPestDialog,
        backgroundColor: AppColors.primaryOrange,
        icon: const Icon(Icons.bug_report),
        label: const Text('Log Pest Finding'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Pest Risk Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.moderateYellow.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.pest_control, color: AppColors.moderateYellow, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Overall Orchard Pest Risk', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        SizedBox(height: 2),
                        Text('MEDIUM RISK (8%)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.moderateYellow)),
                        SizedBox(height: 2),
                        Text('Active pheromone & yellow delta traps deployed across 4.2 acres', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Zone Pest Pressure Grid
            const Text(
              'Affected Zones Pest Pressure',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildZonePestCard('Zone A', 'LOW', AppColors.healthyGreen, 'No active flushes infected'),
                const SizedBox(width: 8),
                _buildZonePestCard('Zone B', 'MEDIUM', AppColors.moderateYellow, 'Minor leafminer mines'),
                const SizedBox(width: 8),
                _buildZonePestCard('Zone C', 'HIGH', AppColors.diseasedRed, 'Psyllid cluster on shoot tips'),
              ],
            ),
            const SizedBox(height: 20),

            // Recorded Pest Observations List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Field Trap Records & Logs',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text('${farmState.pestReports.length} Logs', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
            const SizedBox(height: 10),

            ...farmState.pestReports.map((report) {
              Color severityColor;
              if (report.severity == 'HIGH') {
                severityColor = AppColors.diseasedRed;
              } else if (report.severity == 'MEDIUM') {
                severityColor = AppColors.moderateYellow;
              } else {
                severityColor = AppColors.healthyGreen;
              }

              final dateStr = DateFormat('dd MMM yyyy').format(report.date);

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              report.pestType,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: severityColor.withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${report.severity} SEVERITY',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: severityColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        report.notes,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const Divider(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${report.zoneName} • ${report.trapCount}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryOrange)),
                          Text(dateStr, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
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

  Widget _buildZonePestCard(String zone, String risk, Color color, String sub) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(zone, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text(risk, style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 14)),
            const SizedBox(height: 4),
            Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
