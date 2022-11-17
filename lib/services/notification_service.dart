import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

class NotificationService {
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'knox_appointment_manager',
        'Appointment Remainders',
        icon: 'ic_stat_access_alarms',
        enableLights: true,
        channelDescription: "Reminds all the appointments added by the user ",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  static Future showScheduledNotification(int id, String title, String body,
      String? payload, DateTime scheduledDate) async {
    _localNotifications.zonedSchedule(
      id,
      title,
      body,
      TZDateTime.from(scheduledDate, local),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  Future init() async {
    initializeTimeZones();
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("ic_stat_access_alarms"),
      ),
    );
  }

  static Future cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }
}
