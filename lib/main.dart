import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'services/auth_service.dart';
import 'services/farm_state_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/main_navigation_scaffold.dart';
import 'screens/dashboard/worker_dashboard_screen.dart';
import 'screens/dashboard/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OrangeAiApp());
}

class OrangeAiApp extends StatelessWidget {
  const OrangeAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FarmStateProvider()),
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: _determineHomeScreen(auth),
          );
        },
      ),
    );
  }

  Widget _determineHomeScreen(AuthService auth) {
    if (!auth.isAuthenticated) {
      return const LoginScreen();
    }

    final role = auth.currentUser?.role ?? AppConstants.roleFarmer;
    if (role == AppConstants.roleWorker) {
      return const WorkerDashboardScreen();
    } else if (role == AppConstants.roleAdmin) {
      return const AdminDashboardScreen();
    } else {
      return const MainNavigationScaffold();
    }
  }
}
