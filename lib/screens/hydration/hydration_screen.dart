import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class HydrationScreen extends StatefulWidget {
  const HydrationScreen({super.key});

  @override
  State<HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<HydrationScreen> {
  int _cups = 0;
  final int _goal = 8;
  final int _cupMl = 250;
  Timer? _reminderTimer;

  // إعدادات
  bool _notificationsEnabled = true;
  double _fontSize = 1.0; // 1.0 = عادي

  @override
  void initState() {
    super.initState();
    _loadCups();
    _loadSettings();
    _startReminder();
  }

  @override
  void dispose() {
    _reminderTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _fontSize = prefs.getDouble('font_size') ?? 1.0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setDouble('font_size', _fontSize);
  }

  void _startReminder() {
    _reminderTimer = Timer.periodic(const Duration(hours: 1), (_) {
      if (_cups < _goal && mounted && _notificationsEnabled) {
        _showReminderDialog();
      }
    });
  }

  void _showReminderDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.reminderTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        content: Text(
          l10n.reminderBody,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4),
              minimumSize: const Size(double.infinity, 44),
            ),
            onPressed: () {
              Navigator.pop(context);
              _addCup();
            },
            child: Text(l10n.drankCup,
                style: const TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.later, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  void _openSettings() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              const Icon(Icons.settings_rounded, color: AppTheme.primaryLight),
              const SizedBox(width: 8),
              Text(l10n.settingsDialogTitle,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ═══════════════════
                //    كتم الإشعارات
                // ═══════════════════
                _settingsSectionTitle(l10n.notificationsSection),
                _settingsCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.waterReminderTitle,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(l10n.everyHour,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      Switch(
                        value: _notificationsEnabled,
                        activeThumbColor: const Color(0xFF06B6D4),
                        onChanged: (val) {
                          setStateDialog(() => _notificationsEnabled = val);
                          setState(() => _notificationsEnabled = val);
                          _saveSettings();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ═══════════════════
                //     حجم الخط
                // ═══════════════════
                _settingsSectionTitle(l10n.fontSizeSection),
                _settingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('A', style: TextStyle(fontSize: 12)),
                          Text(
                            _fontSize == 0.9
                                ? l10n.small
                                : _fontSize == 1.0
                                    ? l10n.normal
                                    : l10n.large,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryLight),
                          ),
                          const Text('A', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      Slider(
                        value: _fontSize,
                        min: 0.9,
                        max: 1.2,
                        divisions: 2,
                        activeColor: const Color(0xFF06B6D4),
                        onChanged: (val) {
                          setStateDialog(() => _fontSize = val);
                          setState(() => _fontSize = val);
                          _saveSettings();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ═══════════════════
                //   عن التطبيق
                // ═══════════════════
                _settingsSectionTitle(l10n.aboutSection),
                _settingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppTheme.primary,
                                  AppTheme.primaryLight
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.psychology_rounded,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Cognitive IQ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(l10n.version('1.0.0'),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.appDescription,
                        style: const TextStyle(fontSize: 13, height: 1.6),
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      _infoRow(l10n.developerLabel, 'Cognitive IQ Team'),
                      _infoRow(l10n.typeLabel, l10n.typeValue),
                      _infoRow(l10n.techLabel, 'Flutter & SQLite'),
                      _infoRow(l10n.yearLabel, '2026'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                minimumSize: const Size(double.infinity, 44),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.okDone,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppTheme.primaryLight,
        ),
      ),
    );
  }

  Widget _settingsCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: child,
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _loadCups() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString('water_date') ?? '';
    final today = DateTime.now().toString().substring(0, 10);

    if (lastDate != today) {
      await prefs.setInt('water_cups', 0);
      await prefs.setString('water_date', today);
    }

    setState(() {
      _cups = prefs.getInt('water_cups') ?? 0;
    });
  }

  Future<void> _addCup() async {
    if (_cups >= _goal) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() => _cups++);
    await prefs.setInt('water_cups', _cups);
  }

  Future<void> _removeCup() async {
    if (_cups <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() => _cups--);
    await prefs.setInt('water_cups', _cups);
  }

  Future<void> _reset() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _cups = 0);
    await prefs.setInt('water_cups', 0);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final txtColor = scheme.onSurface;
    final bgCard = scheme.surface;
    final progress = _cups / _goal;
    final mlDrank = _cups * _cupMl;
    final isDone = _cups >= _goal;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.waterTrackerTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: _openSettings,
            tooltip: l10n.settingsTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _reset,
            tooltip: l10n.resetTooltip,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 16,
                      backgroundColor: bgCard,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDone ? AppTheme.success : const Color(0xFF06B6D4),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_cups / $_goal',
                        style: TextStyle(
                          color: txtColor,
                          fontSize: 36 * _fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(l10n.cupsUnit,
                          style: TextStyle(
                              color: scheme.onSecondary,
                              fontSize: 16 * _fontSize)),
                      Text(l10n.mlOfTotal(mlDrank),
                          style: TextStyle(
                              color: scheme.onSecondary,
                              fontSize: 12 * _fontSize)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDone
                        ? AppTheme.success.withValues(alpha: 0.3)
                        : const Color(0xFF06B6D4).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  isDone
                      ? l10n.goalReached
                      : l10n.cupsLeftForGoal(_goal - _cups),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: txtColor,
                    fontSize: 16 * _fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _notificationsEnabled
                      ? const Color(0xFF06B6D4).withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _notificationsEnabled
                          ? Icons.notifications_rounded
                          : Icons.notifications_off_rounded,
                      color: _notificationsEnabled
                          ? const Color(0xFF06B6D4)
                          : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _notificationsEnabled
                          ? l10n.reminderEveryHourOn
                          : l10n.notificationsOff,
                      style: TextStyle(
                        color: _notificationsEnabled
                            ? const Color(0xFF06B6D4)
                            : Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                itemCount: _goal,
                itemBuilder: (context, index) {
                  final filled = index < _cups;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: filled ? const Color(0xFF06B6D4) : bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF06B6D4).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Icon(
                      Icons.water_drop_rounded,
                      color: filled
                          ? Colors.white
                          : const Color(0xFF06B6D4).withValues(alpha: 0.4),
                      size: 32,
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _removeCup,
                      icon: const Icon(Icons.remove_rounded),
                      label: Text(l10n.cupButtonLabel),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF06B6D4),
                        side: const BorderSide(color: Color(0xFF06B6D4)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: isDone ? null : _addCup,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(
                        l10n.addCupButton,
                        style: TextStyle(
                            fontSize: 16 * _fontSize,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06B6D4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
