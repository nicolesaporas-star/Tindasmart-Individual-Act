
import 'package:flutter/material.dart';

import 'login_screen.dart';
import '../widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _openReport(BuildContext context) {
    Navigator.pushNamed(context, '/report');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.storefront_rounded,
                    size: 76,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Welcome to TindaSmart',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Manage your inventory, monitor sales, '
                    'and make smarter stocking decisions '
                    'for your sari-sari store.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.6,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Reusable button for Login navigation.
                  AppButton(
                    label: 'Get Started',
                    width: 220,
                    height: 52,
                    onPressed: () => _openLogin(context),
                  ),

                  const SizedBox(height: 16),

                  // Reusable button for Report Form navigation.
                  AppButton(
                    label: 'Report an Issue',
                    icon: Icons.report_problem_outlined,
                    width: 220,
                    height: 52,
                    onPressed: () => _openReport(context),
                  ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => _openLogin(context),
                    child: const Text(
                      'Already have an account? Log in',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
