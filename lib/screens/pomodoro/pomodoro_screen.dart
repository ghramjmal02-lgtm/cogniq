import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../services/pomodoro_task_handler.dart';

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
  Timer? _uiTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  static const int _longBreakMinutes = 15;

  static const _kEndTime = 'pomodoro_end_time';
  static const _kIsBreak = 'pomodoro_is_break';
  static const _kIsLongBreak = 'pomodoro_is_long_break';
  static const _kSessions = 'pomodoro_sessions';
  static const _kIsRunning = 'pomodoro_is_running';

  @override
  void initState() {
    super.initState();
    _seconds = AppConstants.pomodoroMinutes * 60;
    _initForegroundTask();
    _restoreState();
  }

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'pomodoro_channel_v2',
        channelName: 'مؤقت البومودورو',
        channelDescription: 'إشعار مؤقت التركيز',
        onlyAlertOnce: true,
        priority: NotificationPriority.HIGH,
        playSound: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1000),
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );

    FlutterForegroundTask.addTaskDataCallback(_onTaskData);
  }

  void _onTaskData(Object data) {
    if (data is int && mounted) {
      setState(() {
        _seconds = data;
        if (_seconds <= 0) {
          _isRunning = false;
        }
      });
    }
  }

  Future<void> _restoreState() async {
    final prefs = await SharedPreferences.getInstance();
    final endTimeMillis = prefs.getInt(_kEndTime);
    final wasRunning = prefs.getBool(_kIsRunning) ?? false;

    _isBreak = prefs.getBool(_kIsBreak) ?? false;
    _isLongBreak = prefs.getBool(_kIsLongBreak) ?? false;
    _sessions = prefs.getInt(_kSessions) ?? 0;

    if (wasRunning && endTimeMillis != null) {
      final remaining =
          ((endTimeMillis - DateTime.now().millisecondsSinceEpoch) / 1000)
              .round();
      if (remaining > 0) {
        setState(() {
          _seconds = remaining;
          _isRunning = true;
        });
        _startUiTicker();
        FlutterForegroundTask.saveData(key: 'finishNotified', value: false);
        return;
      } else {
        // الوقت خلص وانت خارج التطبيق
        await _finishCycleFromBackground(prefs);
      }
    }
    setState(() {
      _seconds = _isBreak
          ? AppConstants.breakMinutes * 60
          : _isLongBreak
              ? _longBreakMinutes * 60
              : AppConstants.pomodoroMinutes * 60;
    });
  }

  Future<void> _finishCycleFromBackground(SharedPreferences prefs) async {
    if (!_isBreak && !_isLongBreak) {
      _sessions++;
      if (_sessions % 4 == 0) {
        _isLongBreak = true;
        _isBreak = false;
      } else {
        _isBreak = true;
        _isLongBreak = false;
      }
    } else {
      _isBreak = false;
      _isLongBreak = false;
    }
    await prefs.setBool(_kIsRunning, false);
    await prefs.setInt(_kSessions, _sessions);
    await prefs.setBool(_kIsBreak, _isBreak);
    await prefs.setBool(_kIsLongBreak, _isLongBreak);
  }

  void _startUiTicker() {
    _uiTimer?.cancel();
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        _uiTimer?.cancel();
        await _completeCycle();
      }
    });
  }

  Future<void> _completeCycle() async {
    await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isRunning = false;
      if (!_isBreak && !_isLongBreak) {
        _sessions++;
        if (_sessions % 4 == 0) {
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

    await prefs.setBool(_kIsRunning, false);
    await prefs.setInt(_kSessions, _sessions);
    await prefs.setBool(_kIsBreak, _isBreak);
    await prefs.setBool(_kIsLongBreak, _isLongBreak);
    await FlutterForegroundTask.stopService();
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    _audioPlayer.dispose();
    FlutterForegroundTask.removeTaskDataCallback(_onTaskData);
    super.dispose();
  }

  Future<void> _startPause() async {
    final prefs = await SharedPreferences.getInstance();

    if (_isRunning) {
      // إيقاف مؤقت
      _uiTimer?.cancel();
      await FlutterForegroundTask.stopService();
      await prefs.setBool(_kIsRunning, false);
      setState(() => _isRunning = false);
    } else {
      final endTime = DateTime.now()
          .add(Duration(seconds: _seconds))
          .millisecondsSinceEpoch;
      await prefs.setInt(_kEndTime, endTime);
      await prefs.setBool(_kIsRunning, true);
      await prefs.setBool(_kIsBreak, _isBreak);
      await prefs.setBool(_kIsLongBreak, _isLongBreak);
      await prefs.setInt(_kSessions, _sessions);

      setState(() => _isRunning = true);

      FlutterForegroundTask.saveData(key: 'endTimeMillis', value: endTime);
      FlutterForegroundTask.saveData(
        key: 'label',
        value: _isLongBreak
            ? 'راحة طويلة'
            : _isBreak
                ? 'راحة'
                : 'وقت التركيز',
      );

      await FlutterForegroundTask.startService(
        notificationTitle: _isBreak || _isLongBreak ? 'راحة' : 'وقت التركيز',
        notificationText: _timeString,
        callback: startCallback,
      );

      _startUiTicker();
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

  Future<void> _reset() async {
    _uiTimer?.cancel();
    await FlutterForegroundTask.stopService();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsRunning, false);
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
