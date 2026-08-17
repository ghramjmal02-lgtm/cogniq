import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  late int _seconds;
  bool _isRunning = false;
  bool _isBreak = false;
  bool _isLongBreak = false;
  int _sessions = 0;
  Timer? _timer;

  static const int _longBreakMinutes = 15;

  @override
  void initState() {
    super.initState();
    _seconds = AppConstants.pomodoroMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPause() {
    final l10n = AppLocalizations.of(context)!;
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_seconds > 0) {
          setState(() => _seconds--);
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
            if (!_isBreak && !_isLongBreak) {
              _sessions++;
              if (_sessions % 4 == 0) {
                // راحة طويلة بعد 4 جلسات
                _isLongBreak = true;
                _isBreak = false;
                _seconds = _longBreakMinutes * 60;
                _showSessionDoneDialog(l10n.fourSessionsDone);
              } else {
                _isBreak = true;
                _isLongBreak = false;
                _seconds = AppConstants.breakMinutes * 60;
                _showSessionDoneDialog(l10n.sessionDoneShortBreak);
              }
            } else {
              _isBreak = false;
              _isLongBreak = false;
              _seconds = AppConstants.pomodoroMinutes * 60;
              _showSessionDoneDialog(l10n.breakDoneFocusTime);
            }
          });
        }
      });
    }
  }

  void _showSessionDoneDialog(String message) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              minimumSize: const Size(double.infinity, 44),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isBreak = false;
      _isLongBreak = false;
      _seconds = AppConstants.pomodoroMinutes * 60;
    });
  }

  String get _timeString {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get _progress {
    int total;
    if (_isLongBreak) {
      total = _longBreakMinutes * 60;
    } else if (_isBreak) {
      total = AppConstants.breakMinutes * 60;
    } else {
      total = AppConstants.pomodoroMinutes * 60;
    }
    return _seconds / total;
  }

  String _sessionLabel(AppLocalizations l10n) {
    if (_isLongBreak) return l10n.longBreakLabel;
    if (_isBreak) return l10n.breakTimeLabel;
    return l10n.focusTimeLabel;
  }

  Color get _timerColor {
    if (_isLongBreak) return const Color(0xFF8B5CF6);
    if (_isBreak) return AppTheme.success;
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final txtColor = scheme.onSurface;
    final bgCard = scheme.surface;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pomodoroTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: _timerColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _sessionLabel(l10n),
                  style: TextStyle(
                    color: _timerColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 14,
                      backgroundColor: bgCard,
                      valueColor: AlwaysStoppedAnimation<Color>(_timerColor),
                    ),
                  ),
                  Text(
                    _timeString,
                    style: TextStyle(
                      color: txtColor,
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < (_sessions % 4) ? _timerColor : bgCard,
                      border: Border.all(color: _timerColor),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.sessionsCompleted(_sessions),
                style: TextStyle(color: scheme.onSecondary, fontSize: 14),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  IconButton(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: bgCard,
                      padding: const EdgeInsets.all(16),
                    ),
                    color: scheme.onSecondary,
                    iconSize: 28,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _startPause,
                      icon: Icon(
                        _isRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 28,
                      ),
                      label: Text(
                        _isRunning ? l10n.pause : l10n.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _timerColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _timerColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: scheme.onSecondary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.pomodoroInfo(AppConstants.pomodoroMinutes,
                            AppConstants.breakMinutes, _longBreakMinutes),
                        style: TextStyle(
                          color: scheme.onSecondary,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
