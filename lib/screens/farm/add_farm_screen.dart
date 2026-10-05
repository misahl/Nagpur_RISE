import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/farm_model.dart';
import '../../services/farm_state_provider.dart';
import '../../services/auth_service.dart';
import '../../core/constants/app_colors.dart';

class AddFarmScreen extends StatefulWidget {
  const AddFarmScreen({super.key});

  @override
  State<AddFarmScreen> createState() => _AddFarmScreenState();
}

class _AddFarmScreenState extends State<AddFarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _areaController = TextEditingController();
  final _treesController = TextEditingController();
  final _ageController = TextEditingController();

  String _orangeVariety = 'Nagpur Mandarin';
  String _soilType = 'Black Soil / Sandy Loam';
  String _irrigationType = 'Automated Drip System';

  final List<String> _varieties = [
    'Nagpur Mandarin (Citrus reticulata)',
    'Nagpur Seedless Hybrid',
    'Mosambi (Sweet Lime)',
    'Kinnow Mandarin',
    'Coorg Orange',
  ];

  final List<String> _soilTypes = [
    'Black Soil / Sandy Loam',
    'Clay Loam with High Drainage',
    'Alluvial Fertile Soil',
    'Red Laterite Soil',
  ];

  final List<String> _irrigationTypes = [
    'Automated Drip System',
    'Micro-Sprinkler Network',
    'Surface Drip with Sensor Valves',
    'Basin Flood Irrigation',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _areaController.dispose();
    _treesController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _saveFarm() {
    if (_formKey.currentState!.validate()) {
      final farmState = Provider.of<FarmStateProvider>(context, listen: false);
      final auth = Provider.of<AuthService>(context, listen: false);

      final newFarm = FarmModel(
        id: 'farm_${DateTime.now().millisecondsSinceEpoch}',
        ownerId: auth.currentUser?.id ?? 'farmer_01',
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        areaAcres: double.tryParse(_areaController.text.trim()) ?? 3.0,
        orangeVariety: _orangeVariety,
        numberOfTrees: int.tryParse(_treesController.text.trim()) ?? 800,
        treeAgeYears: int.tryParse(_ageController.text.trim()) ?? 5,
        soilType: _soilType,
        irrigationType: _irrigationType,
        healthScore: 89.0,
        diseaseRisk: 10.0,
        pestRisk: 7.0,
      );

      farmState.addFarm(newFarm);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Farm "${newFarm.name}" registered successfully in Firestore!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register New Farm')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Farm Registration Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              const Text(
                'Enter orchard metadata for automated health scoring, satellite mapping & irrigation scheduling.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // Farm Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Farm Name',
                  prefixIcon: Icon(Icons.agriculture, color: AppColors.primaryOrange),
                  hintText: 'e.g. Sunrise Citrus Orchard',
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter farm name' : null,
              ),
              const SizedBox(height: 14),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Farm Location / GPS Coordinates',
                  prefixIcon: Icon(Icons.pin_drop_outlined, color: AppColors.primaryOrange),
                  hintText: 'e.g. Katol Road, Nagpur, MH',
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter location' : null,
              ),
              const SizedBox(height: 14),

              // Area & Tree Count
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _areaController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Area (Acres)',
                        prefixIcon: Icon(Icons.square_foot, color: AppColors.primaryOrange),
                        hintText: 'e.g. 4.5',
                      ),
                      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _treesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Number of Trees',
                        prefixIcon: Icon(Icons.park, color: AppColors.primaryOrange),
                        hintText: 'e.g. 1200',
                      ),
                      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Tree Age
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Average Tree Age (Years)',
                  prefixIcon: Icon(Icons.cake_outlined, color: AppColors.primaryOrange),
                  hintText: 'e.g. 6',
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter tree age' : null,
              ),
              const SizedBox(height: 14),

              // Orange Variety Dropdown
              DropdownButtonFormField<String>(
                value: _orangeVariety,
                decoration: const InputDecoration(
                  labelText: 'Orange Variety',
                  prefixIcon: Icon(Icons.eco, color: AppColors.primaryOrange),
                ),
                items: _varieties.map((v) => DropdownMenuItem(value: v, child: Text(v, overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (val) => setState(() => _orangeVariety = val ?? _orangeVariety),
              ),
              const SizedBox(height: 14),

              // Soil Type Dropdown
              DropdownButtonFormField<String>(
                value: _soilType,
                decoration: const InputDecoration(
                  labelText: 'Soil Type',
                  prefixIcon: Icon(Icons.layers, color: AppColors.primaryOrange),
                ),
                items: _soilTypes.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (val) => setState(() => _soilType = val ?? _soilType),
              ),
              const SizedBox(height: 14),

              // Irrigation Type Dropdown
              DropdownButtonFormField<String>(
                value: _irrigationType,
                decoration: const InputDecoration(
                  labelText: 'Irrigation System',
                  prefixIcon: Icon(Icons.water, color: AppColors.primaryOrange),
                ),
                items: _irrigationTypes.map((i) => DropdownMenuItem(value: i, child: Text(i, overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (val) => setState(() => _irrigationType = val ?? _irrigationType),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveFarm,
                child: const Text('Save & Initialize Farm Zones'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
