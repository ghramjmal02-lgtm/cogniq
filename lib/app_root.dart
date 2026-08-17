import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cogniq/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home/home_screen.dart';

class CogniqApp extends StatefulWidget {
  final bool isRegistered;
  final bool isDark;
  final bool isArabic;

  const CogniqApp({
    super.key,
    required this.isRegistered,
    required this.isDark,
    required this.isArabic,
  });

  // عشان نقدر نغير الثيم واللغة من أي شاشة
  static _CogniqAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_CogniqAppState>();

  @override
  State<CogniqApp> createState() => _CogniqAppState();
}

class _CogniqAppState extends State<CogniqApp> {
  late bool _isDark;
  late bool _isArabic;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDark;
    _isArabic = widget.isArabic;
  }

  // دالة تغيير الثيم
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = !_isDark;
    });
    await prefs.setBool('is_dark_mode', _isDark);
  }

  // دالة تغيير اللغة
  Future<void> setArabic(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isArabic = value;
    });
    await prefs.setBool('is_arabic', value);
  }

  bool get isDark => _isDark;
  bool get isArabic => _isArabic;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cogniq',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(_isArabic ? 'ar' : 'en'),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'), // العربية
        Locale('en', 'US'), // الإنجليزية
      ],
      home: widget.isRegistered ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
