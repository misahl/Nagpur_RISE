import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import 'disease_result_screen.dart';

class AiCropScanScreen extends StatefulWidget {
  const AiCropScanScreen({super.key});

  @override
  State<AiCropScanScreen> createState() => _AiCropScanScreenState();
}

class _AiCropScanScreenState extends State<AiCropScanScreen> {
  final ImagePicker _picker = ImagePicker();
  dynamic _selectedImage = 'assets/images/canker_leaf.jpg'; // Pre-loaded realistic sample
  String _selectedZoneId = 'zone_b';
  String _selectedTreeCode = 'Tree B-042';
  String _targetDisease = 'Citrus Canker';
  bool _isAnalyzing = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Using high-resolution sample orange leaf for diagnosis.')),
      );
      setState(() {
        _selectedImage = 'assets/images/canker_leaf.jpg';
      });
    }
  }

  void _runAnalysis() async {
    setState(() => _isAnalyzing = true);

    final farmState = Provider.of<FarmStateProvider>(context, listen: false);

    final scanResult = await farmState.runAiScan(
      imageFile: _selectedImage,
      zoneId: _selectedZoneId,
      treeCode: _selectedTreeCode,
      forcedDisease: _targetDisease,
    );

    setState(() => _isAnalyzing = false);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DiseaseResultScreen(scanResult: scanResult),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Crop Scanner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.orangeSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primaryOrange.withAlpha(80)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.smart_toy_outlined, color: AppColors.primaryOrange, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deep Learning Citrus Diagnostics',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.orangeDark),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Instant detection of Citrus Canker, Greening, Leaf Miner, Fungi & Nutrient Deficiencies.',
                          style: TextStyle(fontSize: 11, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Image Preview Box
            Container(
              height: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_selectedImage is File)
                      Image.file(_selectedImage as File, fit: BoxFit.cover)
                    else if (_selectedImage is String)
                      Image.asset(_selectedImage as String, fit: BoxFit.cover)
                    else
                      Container(
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image_outlined, size: 48, color: Colors.grey),
                      ),

                    // Overlay scanning reticle
                    if (_isAnalyzing)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(color: AppColors.primaryOrange),
                              SizedBox(height: 16),
                              Text(
                                'AI Neural Engine Analyzing Leaf...',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Segmenting lesions & chlorotic halos',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Image Picker Buttons (Camera, Gallery, Sample)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isAnalyzing ? null : () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: const Text('Camera', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isAnalyzing ? null : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Gallery', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing
                        ? null
                        : () {
                            setState(() {
                              _selectedImage = 'assets/images/canker_leaf.jpg';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Loaded Nagpur Citrus Canker sample leaf!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                    icon: const Icon(Icons.eco, size: 18),
                    label: const Text('Sample', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Metadata inputs: Zone and Tree selection
            const Text(
              'Field Target Location',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedZoneId,
                    decoration: const InputDecoration(labelText: 'Target Zone'),
                    items: farmState.zones.map((z) {
                      return DropdownMenuItem(value: z.id, child: Text(z.name));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedZoneId = val ?? 'zone_b'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedTreeCode,
                    decoration: const InputDecoration(labelText: 'Tree ID'),
                    items: farmState.trees.map((t) {
                      return DropdownMenuItem(value: t.treeCode, child: Text(t.treeCode));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedTreeCode = val ?? 'Tree B-042'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Diagnostic Model Category (For Demo switching)
            DropdownButtonFormField<String>(
              value: _targetDisease,
              decoration: const InputDecoration(
                labelText: 'AI Diagnostic Category (Simulation Preset)',
                prefixIcon: Icon(Icons.biotech, color: AppColors.primaryOrange),
              ),
              items: AppConstants.diseaseClasses.map((d) {
                return DropdownMenuItem(value: d, child: Text(d));
              }).toList(),
              onChanged: (val) => setState(() => _targetDisease = val ?? 'Citrus Canker'),
            ),
            const SizedBox(height: 24),

            // Run Analysis Button
            ElevatedButton(
              onPressed: _isAnalyzing ? null : _runAnalysis,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: _isAnalyzing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_fix_high),
                        SizedBox(width: 8),
                        Text(
                          'Analyze Image with AI',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
