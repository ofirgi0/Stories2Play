import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleGoogleLogin(BuildContext context) async {
    final account = await AuthService().signInWithGoogle();
    if (account != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', account.displayName ?? 'User');
      await prefs.setString('userEmail', account.email);
      // Proceed to main screen
      _goToMainScreen(context);
    }
  }

  Future<void> _handleSkipLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', 'Guest');
    // Proceed to main screen
    _goToMainScreen(context);
  }

  void _goToMainScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome to Stories2Play",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => _handleGoogleLogin(context),
                icon: const Icon(Icons.login),
                label: const Text("Continue with Google"),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Apple sign-in optional
                },
                icon: const Icon(Icons.apple),
                label: const Text("Continue with Apple"),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => _handleSkipLogin(context),
                child: const Text("Skip for now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
