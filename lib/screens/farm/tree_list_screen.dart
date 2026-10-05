import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';
import 'tree_details_screen.dart';

class TreeListScreen extends StatefulWidget {
  const TreeListScreen({super.key});

  @override
  State<TreeListScreen> createState() => _TreeListScreenState();
}

class _TreeListScreenState extends State<TreeListScreen> {
  String _searchQuery = '';
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final trees = farmState.trees.where((t) {
      final matchesSearch = t.treeCode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.variety.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'All' || t.currentStatus == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orange Tree Registry'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search tree ID (e.g. Tree B-042)...',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
                const SizedBox(height: 10),

                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Healthy', 'Needs Inspection', 'Diseased'].map((status) {
                      final isSelected = _selectedStatus == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          selectedColor: AppColors.primaryOrange.withAlpha(40),
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primaryOrange : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedStatus = status);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: trees.length,
              itemBuilder: (context, index) {
                final tree = trees[index];
                Color statusColor;
                if (tree.currentStatus == 'Healthy') {
                  statusColor = AppColors.healthyGreen;
                } else if (tree.currentStatus == 'Needs Inspection') {
                  statusColor = AppColors.inspectionOrange;
                } else {
                  statusColor = AppColors.diseasedRed;
                }

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: statusColor.withAlpha(25),
                      child: Icon(Icons.park, color: statusColor),
                    ),
                    title: Text(tree.treeCode, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${tree.variety} • Age: ${tree.ageYears} yrs • Health: ${tree.healthScore.toInt()}%'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tree.currentStatus,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TreeDetailsScreen(tree: tree)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
