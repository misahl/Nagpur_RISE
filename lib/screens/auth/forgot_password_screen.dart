import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../core/constants/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _submitted = false;
  String _message = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleReset() async {
    final text = _emailController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter registered phone or email')),
      );
      return;
    }

    final auth = Provider.of<AuthService>(context, listen: false);
    final msg = await auth.resetPassword(text);

    setState(() {
      _submitted = true;
      _message = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_reset, size: 36, color: AppColors.primaryOrange),
              ),
              const SizedBox(height: 20),
              const Text(
                'Forgot Your Password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your registered email or phone number. We will send a secure verification OTP and password reset instructions.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),

              if (_submitted) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.greenSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.healthyGreen.withAlpha(80)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.healthyGreen),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _message,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greenDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Return to Login'),
                ),
              ] else ...[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Phone or Email',
                    prefixIcon: Icon(Icons.contact_mail_outlined, color: AppColors.primaryOrange),
                    hintText: 'e.g. +91 98234 56789 or user@orangeai.farm',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleReset,
                  child: const Text('Send Password Reset Link'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
