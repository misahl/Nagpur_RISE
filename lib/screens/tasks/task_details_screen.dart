import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/task_model.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';

class TaskDetailsScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TextEditingController _notesController;
  final ImagePicker _picker = ImagePicker();
  dynamic _inspectionImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(
      text: widget.task.inspectionNotes.isNotEmpty
          ? widget.task.inspectionNotes
          : 'Inspected target tree canopy. Applied Copper Oxychloride 50 WP (3g/L). Sanitize pruning shears.',
    );
    if (widget.task.inspectionImageUrl.isNotEmpty) {
      _inspectionImage = widget.task.inspectionImageUrl;
    } else {
      _inspectionImage = 'assets/images/canker_leaf.jpg';
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        setState(() => _inspectionImage = File(picked.path));
      }
    } catch (_) {
      setState(() => _inspectionImage = 'assets/images/canker_leaf.jpg');
    }
  }

  void _markComplete() async {
    setState(() => _isSaving = true);
    final farmState = Provider.of<FarmStateProvider>(context, listen: false);

    farmState.completeTask(
      taskId: widget.task.id,
      inspectionNotes: _notesController.text.trim(),
      inspectionPhoto: _inspectionImage is File ? _inspectionImage.path : 'assets/images/canker_leaf.jpg',
    );

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task marked completed! Farm health index updated.'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.task.status.toLowerCase() == 'completed';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Task Inspection'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Task Header
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${widget.task.priority.toUpperCase()} PRIORITY',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDone ? AppColors.greenSurface : Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.task.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDone ? AppColors.healthyGreen : Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.task.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.task.description,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
                  ),
                  const Divider(height: 24),

                  _buildRow('Assigned Zone', widget.task.zoneName, Icons.layers_outlined),
                  const SizedBox(height: 8),
                  _buildRow('Assigned Worker', widget.task.assignedWorkerName, Icons.person_outline),
                  const SizedBox(height: 8),
                  _buildRow('Deadline', widget.task.deadline, Icons.schedule),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Inspection Photo Upload Section
            const Text(
              'Field Verification Photo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_inspectionImage is File)
                      Image.file(_inspectionImage as File, fit: BoxFit.cover)
                    else if (_inspectionImage is String && _inspectionImage.isNotEmpty)
                      Image.asset(_inspectionImage as String, fit: BoxFit.cover)
                    else
                      Container(
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey),
                      ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: ElevatedButton.icon(
                        onPressed: _pickPhoto,
                        icon: const Icon(Icons.camera_alt, size: 16),
                        label: const Text('Capture Photo', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Worker Notes
            const Text(
              'Worker Inspection Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter observation, treatment spray applied, or tree status...',
              ),
            ),
            const SizedBox(height: 24),

            // Complete Task Button
            ElevatedButton(
              onPressed: _isSaving ? null : _markComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDone ? Colors.grey : AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSaving
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(isDone ? 'Update Inspection Report' : 'MARK TASK COMPLETED'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryOrange),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
