import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final prefs = await SharedPreferences.getInstance();
  final isRegistered = prefs.getBool('is_registered') ?? false;
  final isDark = prefs.getBool('is_dark_mode') ?? true;
  final isArabic = prefs.getBool('is_arabic') ?? true;

  runApp(CogniqApp(
    isRegistered: isRegistered,
    isDark: isDark,
    isArabic: isArabic,
  ));
}
