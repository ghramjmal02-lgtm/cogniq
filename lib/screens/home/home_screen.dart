import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../exam_schedule/exam_schedule_screen.dart';
import '../pomodoro/pomodoro_screen.dart';
import '../notes/notes_screen.dart';
import '../brain_game/brain_game_screen.dart';
import '../hydration/hydration_screen.dart';
import '../settings/settings_screen.dart';
import '../../app_root.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _userName = '';
  String _studyYear = '';
  String _quote = '';
  int _waterCups = 0;
  int _pomodoroSessions = 0;

  final List<Widget> _screens = [
    const ExamScheduleScreen(),
    const PomodoroScreen(),
    const NotesScreen(),
    const BrainGameScreen(),
    const HydrationScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? '';
      _studyYear = prefs.getString('study_year') ?? '';
      _waterCups = prefs.getInt('water_cups') ?? 0;
      _pomodoroSessions = prefs.getInt('pomodoro_sessions') ?? 0;
    });
  }

  void _loadQuote() {
    final quotes = AppConstants.motivationalQuotes;
    final random = DateTime.now().millisecondsSinceEpoch % quotes.length;
    setState(() => _quote = quotes[random]);
  }

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning;
    if (hour < 17) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  String _getDayName(AppLocalizations l10n) {
    final days = [
      l10n.monday,
      l10n.tuesday,
      l10n.wednesday,
      l10n.thursday,
      l10n.friday,
      l10n.saturday,
      l10n.sunday,
    ];
    return days[DateTime.now().weekday - 1];
  }

  String _getMonthName(AppLocalizations l10n) {
    final months = [
      l10n.january,
      l10n.february,
      l10n.march,
      l10n.april,
      l10n.may,
      l10n.june,
      l10n.july,
      l10n.august,
      l10n.september,
      l10n.october,
      l10n.november,
      l10n.december,
    ];
    return months[DateTime.now().month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHomeTab(),
    );
  }

  Widget _buildHomeTab() {
    final scheme = Theme.of(context).colorScheme;
    final isDark = CogniqApp.of(context)?.isDark ?? true;
    final bgColor = scheme.surface;
    final txtColor = scheme.onSurface;
    final subColor = scheme.onSecondary;
    final l10n = AppLocalizations.of(context)!;

    if (_quote.isEmpty) {
      final quotes = AppConstants.motivationalQuotes;
      final random = DateTime.now().millisecondsSinceEpoch % quotes.length;
      _quote = quotes[random];
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // الهيدر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_getGreeting(l10n),
                        style: TextStyle(color: subColor, fontSize: 13)),
                    Text(_userName.isEmpty ? l10n.defaultStudent : _userName,
                        style: TextStyle(
                            color: txtColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    Text(
                        '${_getDayName(l10n)}، ${DateTime.now().day} ${_getMonthName(l10n)}',
                        style: TextStyle(color: subColor, fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    _buildIconButton(Icons.settings_rounded, () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingsScreen()));
                      _loadData();
                    }, subColor, bgColor),
                    const SizedBox(width: 8),
                    _buildIconButton(
                        isDark
                            ? Icons.wb_sunny_rounded
                            : Icons.nightlight_rounded,
                        () => CogniqApp.of(context)?.toggleTheme(),
                        isDark ? Colors.amber : Colors.indigo,
                        bgColor),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // إحصائيات
            _buildStatsContainer(l10n),
            const SizedBox(height: 12),

            // اقتباس
            _buildQuoteContainer(txtColor, bgColor),
            const SizedBox(height: 20),

            // الأدوات
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildToolCard(Icons.calendar_today_rounded, l10n.examSchedule,
                    l10n.exams, const Color(0xFF3B82F6), 1),
                _buildToolCard(Icons.timer_rounded, l10n.pomodoro, l10n.focus,
                    const Color(0xFFEF4444), 2),
                _buildToolCard(Icons.note_rounded, l10n.notes,
                    l10n.recordThoughts, const Color(0xFF10B981), 3),
                _buildToolCard(Icons.psychology_rounded, l10n.game, l10n.memory,
                    const Color(0xFF8B5CF6), 4),
                _buildToolCard(Icons.water_drop_rounded, l10n.water,
                    l10n.tracker, const Color(0xFF06B6D4), 5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, VoidCallback onTap, Color iconColor, Color bgColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3))),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }

  Widget _buildStatsContainer(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppTheme.primary,
            AppTheme.primary.withValues(alpha: 0.7)
          ]),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
              Icons.water_drop_rounded, '$_waterCups/8', l10n.cupsOfWater),
          _buildStatItem(
              Icons.timer_rounded, '$_pomodoroSessions', l10n.sessions),
          _buildStatItem(
              Icons.calendar_today_rounded, _getDayName(l10n), l10n.today),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String val, String label) {
    return Column(children: [
      Icon(icon, color: Colors.white, size: 20),
      Text(val,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10))
    ]);
  }

  Widget _buildQuoteContainer(Color txtColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3))),
      child: Row(children: [
        const Icon(Icons.lightbulb_rounded, color: Colors.amber, size: 20),
        const SizedBox(width: 10),
        Expanded(
            child:
                Text(_quote, style: TextStyle(color: txtColor, fontSize: 12)))
      ]),
    );
  }

  Widget _buildToolCard(
      IconData icon, String title, String subtitle, Color color, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => _screens[index - 1]),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 2),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
