import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../services/farm_state_provider.dart';
import 'farmer_dashboard_screen.dart';
import '../farm/farm_details_screen.dart';
import '../ai_scan/ai_crop_scan_screen.dart';
import '../alerts/alerts_screen.dart';
import '../profile/profile_screen.dart';
import '../assistant/ai_assistant_screen.dart';

class MainNavigationScaffold extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onBottomNavTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final unreadAlerts = farmState.alerts.where((a) => !a.isRead).length;

    final List<Widget> pages = [
      FarmerDashboardScreen(onNavigateToTab: _onBottomNavTapped),
      FarmDetailsScreen(farm: farmState.currentFarm),
      const AiCropScanScreen(),
      const AlertsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('🍊', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'OrangeAI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  farmState.currentFarm.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Demo Mode pill button
          GestureDetector(
            onTap: () {
              farmState.toggleDemoMode(!farmState.isDemoMode);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(farmState.isDemoMode ? 'Demo Mode Active (Simulated Sensors & Scans)' : 'Live Mode Active'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: farmState.isDemoMode ? AppColors.primaryOrange.withAlpha(25) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: farmState.isDemoMode ? AppColors.primaryOrange : Colors.grey.shade400,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bolt,
                    size: 13,
                    color: farmState.isDemoMode ? AppColors.primaryOrange : Colors.grey,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    'DEMO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: farmState.isDemoMode ? AppColors.primaryOrange : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Notification Bell
          IconButton(
            icon: Badge(
              isLabelVisible: unreadAlerts > 0,
              label: Text('$unreadAlerts'),
              backgroundColor: AppColors.diseasedRed,
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => setState(() => _currentIndex = 3),
          ),

          // AI Assistant Shortcut
          IconButton(
            tooltip: 'AI Farm Assistant',
            icon: const Icon(Icons.smart_toy_outlined, color: AppColors.primaryGreen),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiAssistantScreen()),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.park_outlined),
            activeIcon: Icon(Icons.park),
            label: 'FARM',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner_outlined),
            activeIcon: Icon(Icons.document_scanner),
            label: 'AI SCAN',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'ALERTS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }
}
