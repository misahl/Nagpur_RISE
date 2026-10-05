import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../dashboard/main_navigation_scaffold.dart';
import '../dashboard/worker_dashboard_screen.dart';
import '../dashboard/admin_dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _villageController = TextEditingController(text: 'Kalmeshwar');
  final _districtController = TextEditingController(text: 'Nagpur');
  final _stateController = TextEditingController(text: 'Maharashtra');
  String _selectedRole = AppConstants.roleFarmer;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _villageController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final auth = Provider.of<AuthService>(context, listen: false);
      final success = await auth.register(
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        village: _villageController.text.trim(),
        district: _districtController.text.trim(),
        state: _stateController.text.trim(),
        role: _selectedRole,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Welcome to OrangeAI.'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );

        Widget target;
        if (_selectedRole == AppConstants.roleWorker) {
          target = const WorkerDashboardScreen();
        } else if (_selectedRole == AppConstants.roleAdmin) {
          target = const AdminDashboardScreen();
        } else {
          target = const MainNavigationScaffold();
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => target),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Join OrangeAI Smart Farming',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Connect your orange orchard to AI crop health diagnostics & precision automation.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),

                // Role selection dropdown
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'User Role',
                    prefixIcon: Icon(Icons.badge_outlined, color: AppColors.primaryOrange),
                  ),
                  items: [
                    AppConstants.roleFarmer,
                    AppConstants.roleWorker,
                    AppConstants.roleAdmin,
                  ].map((role) {
                    return DropdownMenuItem(value: role, child: Text(role));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedRole = val ?? AppConstants.roleFarmer),
                ),
                const SizedBox(height: 14),

                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person, color: AppColors.primaryOrange),
                    hintText: 'e.g. Ramesh Patel',
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? 'Please enter full name' : null,
                ),
                const SizedBox(height: 14),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Phone',
                    prefixIcon: Icon(Icons.phone, color: AppColors.primaryOrange),
                    hintText: '+91 98234 56789',
                  ),
                  validator: (val) => (val == null || val.length < 10) ? 'Enter valid 10-digit phone' : null,
                ),
                const SizedBox(height: 14),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryOrange),
                    hintText: 'farmer@example.com',
                  ),
                  validator: (val) => (val == null || !val.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 14),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryOrange),
                    hintText: 'Minimum 6 characters',
                  ),
                  validator: (val) => (val == null || val.length < 6) ? 'Password must be at least 6 chars' : null,
                ),
                const SizedBox(height: 14),

                // Village, District, State
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _villageController,
                        decoration: const InputDecoration(
                          labelText: 'Village',
                          prefixIcon: Icon(Icons.home_work_outlined, color: AppColors.primaryOrange),
                        ),
                        validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _districtController,
                        decoration: const InputDecoration(
                          labelText: 'District',
                          prefixIcon: Icon(Icons.location_city, color: AppColors.primaryOrange),
                        ),
                        validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State',
                    prefixIcon: Icon(Icons.map_outlined, color: AppColors.primaryOrange),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: auth.isLoading ? null : _handleRegister,
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text('Complete Registration'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
