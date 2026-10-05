import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';

class AssignTaskScreen extends StatefulWidget {
  final String? initialZone;
  final String? initialTitle;

  const AssignTaskScreen({super.key, this.initialZone, this.initialTitle});

  @override
  State<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  final _deadlineController = TextEditingController(text: 'Today, 5:30 PM');

  String _selectedZone = 'Zone B';
  String _selectedPriority = 'High';
  String _selectedWorker = 'Ramesh Pawar';

  final List<String> _workers = [
    'Ramesh Pawar',
    'Suresh More',
    'Anil Deshmukh',
    'Vijay Jadhav',
  ];

  @override
  void initState() {
    super.initState();
    _selectedZone = widget.initialZone ?? 'Zone B';
    _titleController = TextEditingController(
      text: widget.initialTitle ?? 'Inspect Zone B Orange Tree Leafminer & Canker',
    );
    _descController = TextEditingController(
      text: 'Conduct close-range canopy inspection, spray Copper Oxychloride 50 WP, and check sticky pest traps.',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final farmState = Provider.of<FarmStateProvider>(context, listen: false);

      final newTask = TaskModel(
        id: 'task_${DateTime.now().millisecondsSinceEpoch}',
        farmId: farmState.currentFarm.id,
        zoneId: _selectedZone.toLowerCase().replaceAll(' ', '_'),
        zoneName: _selectedZone,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        priority: _selectedPriority,
        assignedWorkerId: 'worker_01',
        assignedWorkerName: _selectedWorker,
        deadline: _deadlineController.text.trim(),
        status: 'Pending',
      );

      farmState.assignNewTask(newTask);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task assigned to $_selectedWorker!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Assign Field Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  prefixIcon: Icon(Icons.title, color: AppColors.primaryOrange),
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Task Description & Instructions',
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: _selectedZone,
                decoration: const InputDecoration(
                  labelText: 'Target Zone',
                  prefixIcon: Icon(Icons.layers, color: AppColors.primaryOrange),
                ),
                items: farmState.zones.map((z) => DropdownMenuItem(value: z.name, child: Text(z.name))).toList(),
                onChanged: (val) => setState(() => _selectedZone = val ?? _selectedZone),
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: _selectedWorker,
                decoration: const InputDecoration(
                  labelText: 'Assign Worker',
                  prefixIcon: Icon(Icons.person, color: AppColors.primaryOrange),
                ),
                items: _workers.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                onChanged: (val) => setState(() => _selectedWorker = val ?? _selectedWorker),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: ['Low', 'Medium', 'High'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                      onChanged: (val) => setState(() => _selectedPriority = val ?? 'High'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _deadlineController,
                      decoration: const InputDecoration(
                        labelText: 'Deadline',
                        prefixIcon: Icon(Icons.schedule),
                      ),
                      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitTask,
                child: const Text('Dispatch Task to Worker'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
