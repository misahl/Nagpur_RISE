import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../services/farm_state_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/task_card.dart';
import '../../widgets/alert_card.dart';
import '../tasks/task_details_screen.dart';
import 'main_navigation_scaffold.dart';
import '../auth/login_screen.dart';

class WorkerDashboardScreen extends StatefulWidget {
  const WorkerDashboardScreen({super.key});

  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  int _selectedFilterIndex = 0; // 0: My Tasks, 1: Pending, 2: Completed

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final auth = Provider.of<AuthService>(context);
    final workerName = auth.currentUser?.name ?? 'Ramesh Pawar';

    final allTasks = farmState.tasks;
    final myTasks = allTasks.where((t) => t.assignedWorkerId == 'worker_01').toList();
    final pendingTasks = myTasks.where((t) => t.status != 'Completed').toList();
    final completedTasks = myTasks.where((t) => t.status == 'Completed').toList();

    List displayedTasks = myTasks;
    if (_selectedFilterIndex == 1) displayedTasks = pendingTasks;
    if (_selectedFilterIndex == 2) displayedTasks = completedTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.engineering_outlined, color: AppColors.primaryOrange),
            SizedBox(width: 8),
            Text('Field Worker Portal'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Switch to Farmer View',
            icon: const Icon(Icons.swap_horiz, color: AppColors.primaryGreen),
            onPressed: () {
              auth.switchRole('Farmer');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigationScaffold()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Worker Greeting Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryGreen, AppColors.greenDark],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workerName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Assigned to: Green Valley Orange Farm',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${pendingTasks.length} Pending Actions Today',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Statistics Row
            Row(
              children: [
                _buildStatPill('Assigned', '${myTasks.length}', AppColors.primaryOrange),
                const SizedBox(width: 8),
                _buildStatPill('Pending', '${pendingTasks.length}', AppColors.diseasedRed),
                const SizedBox(width: 8),
                _buildStatPill('Completed', '${completedTasks.length}', AppColors.healthyGreen),
              ],
            ),
            const SizedBox(height: 18),

            // Filter Tabs
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _buildTab('All My Tasks', 0),
                  _buildTab('Pending (${pendingTasks.length})', 1),
                  _buildTab('Completed (${completedTasks.length})', 2),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Task List
            const Text(
              'Field Tasks & Inspections',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            if (displayedTasks.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: const Text('No tasks found in this view.'),
              )
            else
              ...displayedTasks.map((task) {
                return TaskCard(
                  task: task,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task)),
                    );
                  },
                  onStatusToggle: (val) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task)),
                    );
                  },
                );
              }),
            const SizedBox(height: 20),

            // Farm Alerts for Workers
            const Text(
              'Priority Farm Field Alerts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            ...farmState.alerts.take(2).map((alert) {
              return AlertCard(alert: alert);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPill(String title, String val, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          children: [
            Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedFilterIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilterIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
