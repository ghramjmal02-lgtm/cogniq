import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';
import '../../app_root.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _userName = '';
  String _studyYear = '';
  int _waterGoal = 8;
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final _collegeController = TextEditingController();
  final _majorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _collegeController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('user_name') ?? '';
    String college = '';
    String major = '';

    // قراءة بيانات المستخدم الحالي من Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final data = doc.data();
        if (data != null) {
          name = (data['name'] ?? name).toString();
          college = (data['college'] ?? '').toString();
          major = (data['major'] ?? '').toString();
        }
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() {
      _userName = name;
      _studyYear = prefs.getString('study_year') ?? '';
      _waterGoal = prefs.getInt('water_goal') ?? 8;
      _nameController.text = _userName;
      _yearController.text = _studyYear;
      _collegeController.text = college;
      _majorController.text = major;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text.trim());
    await prefs.setString('study_year', _yearController.text.trim());
    await prefs.setInt('water_goal', _waterGoal);

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.settingsSaved),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  Future<void> _resetApp() async {
    final l10n = AppLocalizations.of(context)!;
    // تأكيد الحذف
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          l10n.resetApp,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          l10n.resetConfirmMessage,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.redAccent,
            ),
            child: Text(l10n.yesDelete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final txtColor = scheme.onSurface;
    final bgCard = scheme.surface;
    final isDark = CogniqApp.of(context)?.isDark ?? true;
    final isArabic = CogniqApp.of(context)?.isArabic ?? true;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ═══════════════════════
              //    معلومات المستخدم
              // ═══════════════════════
              _buildSectionTitle(l10n.yourInfo, txtColor),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      style: TextStyle(color: txtColor),
                      decoration: InputDecoration(
                        labelText: l10n.name,
                        prefixIcon: const Icon(
                          Icons.person_rounded,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _yearController,
                      style: TextStyle(color: txtColor),
                      decoration: InputDecoration(
                        labelText: l10n.studyYear,
                        prefixIcon: const Icon(
                          Icons.school_rounded,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // الكلية (للعرض فقط)
                    TextField(
                      controller: _collegeController,
                      readOnly: true,
                      style: TextStyle(color: txtColor),
                      decoration: InputDecoration(
                        labelText: isArabic ? 'الكلية' : 'College',
                        prefixIcon: const Icon(
                          Icons.account_balance_rounded,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // التخصص (للعرض فقط)
                    TextField(
                      controller: _majorController,
                      readOnly: true,
                      style: TextStyle(color: txtColor),
                      decoration: InputDecoration(
                        labelText: isArabic ? 'التخصص' : 'Major',
                        prefixIcon: const Icon(
                          Icons.menu_book_rounded,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ═══════════════════════
              //    هدف الماء
              // ═══════════════════════
              _buildSectionTitle(l10n.waterGoalTitle, txtColor),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF06B6D4).withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.cupsEqualsMl(_waterGoal, _waterGoal * 250),
                          style: TextStyle(
                            color: txtColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          l10n.liters(
                              (_waterGoal * 250 / 1000).toStringAsFixed(1)),
                          style: const TextStyle(
                            color: Color(0xFF06B6D4),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _waterGoal.toDouble(),
                      min: 4,
                      max: 12,
                      divisions: 8,
                      activeColor: const Color(0xFF06B6D4),
                      inactiveColor:
                          const Color(0xFF06B6D4).withValues(alpha: 0.2),
                      label: '$_waterGoal',
                      onChanged: (value) {
                        setState(() => _waterGoal = value.toInt());
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ═══════════════════════
              //    المظهر
              // ═══════════════════════
              _buildSectionTitle(l10n.appearance, txtColor),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isDark
                              ? Icons.nightlight_rounded
                              : Icons.wb_sunny_rounded,
                          color: isDark ? Colors.indigo : Colors.amber,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isDark ? l10n.darkMode : l10n.lightMode,
                          style: TextStyle(
                            color: txtColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: isDark,
                      onChanged: (_) => CogniqApp.of(context)?.toggleTheme(),
                      activeThumbColor: AppTheme.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ═══════════════════════
              //    اللغة
              // ═══════════════════════
              _buildSectionTitle(l10n.language, txtColor),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.language_rounded,
                          color: AppTheme.primaryLight,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isArabic ? l10n.arabic : l10n.english,
                          style: TextStyle(
                            color: txtColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: isArabic,
                      onChanged: (value) =>
                          CogniqApp.of(context)?.setArabic(value),
                      activeThumbColor: AppTheme.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ═══════════════════════
              //    زرار الحفظ
              // ═══════════════════════
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _saveSettings,
                  icon: const Icon(Icons.save_rounded),
                  label: Text(
                    l10n.saveSettings,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ═══════════════════════
              //    إعادة التعيين
              // ═══════════════════════
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: _resetApp,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.redAccent,
                  ),
                  label: Text(
                    l10n.resetApp,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ═══════════════════════
              //    معلومات التطبيق
              // ═══════════════════════
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.psychology_rounded,
                      color: AppTheme.primaryLight,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.appTitle,
                      style: const TextStyle(
                        color: AppTheme.primaryLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.version('1.0.0'),
                      style: TextStyle(
                        color: scheme.onSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
