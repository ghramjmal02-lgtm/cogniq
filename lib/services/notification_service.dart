import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);

    // اطلب صلاحية الإشعارات (أندرويد 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // اطلب صلاحية الـ exact alarm (أندرويد 12+)
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  /// يجدول إشعار قبل الامتحان بيومين الساعة 9 الصبح
  static Future<void> scheduleExamReminder({
    required int examId,
    required String subject,
    required String examDate, // بصيغة yyyy-MM-dd
  }) async {
    final date = DateTime.parse(examDate);
    final reminderDate = DateTime(date.year, date.month, date.day - 2, 9, 0);

    // لو الموعد فات، متجدولش حاجة
    if (reminderDate.isBefore(DateTime.now())) return;

    const androidDetails = AndroidNotificationDetails(
      'exam_reminders',
      'تذكير الامتحانات',
      channelDescription: 'تنبيه قبل الامتحان بيومين',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      examId, // استخدام نفس الـ id بتاع الامتحان كمعرف الإشعار
      '📚 امتحان قريب!',
      'باقي يومين على امتحان $subject، يلا ذاكري 💪',
      tz.TZDateTime.from(reminderDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// يلغي إشعار امتحان معين (لما يتحذف)
  static Future<void> cancelExamReminder(int examId) async {
    await _plugin.cancel(examId);
  }
}
