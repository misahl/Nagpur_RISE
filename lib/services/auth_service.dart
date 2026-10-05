import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthService() {
    // Default logged-in demo user (Farmer)
    _currentUser = UserModel(
      id: 'farmer_01',
      name: 'Rajesh Patil',
      phone: '+91 98234 56789',
      email: 'rajesh.patil@orangeai.farm',
      village: 'Kalmeshwar',
      district: 'Nagpur',
      state: 'Maharashtra',
      role: AppConstants.roleFarmer,
    );
  }

  Future<bool> login(String identifier, String password, {String role = AppConstants.roleFarmer}) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600)); // Smooth UX transition

    String name = 'Rajesh Patil';
    if (role == AppConstants.roleWorker) {
      name = 'Ramesh Pawar (Field Tech)';
    } else if (role == AppConstants.roleAdmin) {
      name = 'Dr. Sunita Sharma (Agri-Director)';
    }

    _currentUser = UserModel(
      id: role == AppConstants.roleWorker ? 'worker_01' : (role == AppConstants.roleAdmin ? 'admin_01' : 'farmer_01'),
      name: name,
      phone: identifier.contains('@') ? '+91 98234 56789' : identifier,
      email: identifier.contains('@') ? identifier : 'user@orangeai.farm',
      village: 'Kalmeshwar',
      district: 'Nagpur',
      state: 'Maharashtra',
      role: role,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required String village,
    required String district,
    required String state,
    required String role,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: fullName,
      phone: phone,
      email: email,
      village: village,
      district: district,
      state: state,
      role: role,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void switchRole(String role) {
    if (_currentUser == null) return;
    _currentUser = UserModel(
      id: _currentUser!.id,
      name: role == AppConstants.roleWorker 
          ? 'Ramesh Pawar' 
          : (role == AppConstants.roleAdmin ? 'Dr. Sunita Sharma' : 'Rajesh Patil'),
      phone: _currentUser!.phone,
      email: _currentUser!.email,
      village: _currentUser!.village,
      district: _currentUser!.district,
      state: _currentUser!.state,
      role: role,
    );
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  Future<String> resetPassword(String emailOrPhone) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return 'Password reset link and OTP sent to $emailOrPhone';
  }
}
