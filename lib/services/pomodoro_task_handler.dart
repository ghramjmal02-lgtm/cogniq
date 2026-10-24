import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class PomodoroTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) async {
    final endTimeMillis =
        await FlutterForegroundTask.getData<int>(key: 'endTimeMillis');
    if (endTimeMillis == null) return;

    final remaining =
        ((endTimeMillis - DateTime.now().millisecondsSinceEpoch) / 1000)
            .round()
            .clamp(0, 999999);

    final m = (remaining ~/ 60).toString().padLeft(2, '0');
    final s = (remaining % 60).toString().padLeft(2, '0');

    final label =
        await FlutterForegroundTask.getData<String>(key: 'label') ?? 'تركيز';

    final alreadyNotified =
        await FlutterForegroundTask.getData<bool>(key: 'finishNotified') ??
            false;

    if (remaining <= 0 && !alreadyNotified) {
      await FlutterForegroundTask.saveData(key: 'finishNotified', value: true);
      FlutterForegroundTask.updateService(
        notificationTitle: '⏰ انتهى الوقت!',
        notificationText: label,
      );
    } else if (remaining > 0) {
      FlutterForegroundTask.updateService(
        notificationTitle: label,
        notificationText: '$m:$s متبقية',
      );
    }

    FlutterForegroundTask.sendDataToMain(remaining);
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {}
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(PomodoroTaskHandler());
}
