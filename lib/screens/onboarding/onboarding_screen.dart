import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  String _quote = '';

  @override
  void initState() {
    super.initState();
    final quotes = AppConstants.motivationalQuotes;
    final random = DateTime.now().millisecondsSinceEpoch % quotes.length;
    _quote = quotes[random];
  }

  Future<void> _saveAndContinue() async {
    if (_nameController.text.isEmpty || _yearController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('من فضلك ادخل اسمك وسنتك الدراسية!'),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text.trim());
    await prefs.setString('study_year', _yearController.text.trim());
    await prefs.setBool('is_registered', true);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // اللوجو
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: Colors.white,
                  size: 56,
                ),
              ),

              const SizedBox(height: 24),

              // اسم التطبيق
              Text(
                'Cogniq',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'رفيقك الذكي في رحلة الدراسة',
                style: TextStyle(
                  color: AppTheme.primaryLight,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              // جملة تحفيزية
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  _quote,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // خانة الاسم
              TextField(
                controller: _nameController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  labelText: 'اسمك',
                  hintText: 'مثال: أحمد محمد',
                  prefixIcon: Icon(
                    Icons.person_rounded,
                    color: AppTheme.primaryLight,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // خانة السنة
              TextField(
                controller: _yearController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  labelText: 'سنتك الدراسية',
                  hintText: 'مثال: الثالثة - تقنية المعلومات',
                  prefixIcon: Icon(
                    Icons.school_rounded,
                    color: AppTheme.primaryLight,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // زرار البدء
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saveAndContinue,
                  child: const Text(
                    'ابدأ رحلتك 🚀',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
