import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  Future<FlutterLocalNotificationsPlugin> initNotif() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    return FlutterLocalNotificationsPlugin();
  }

  Future showNotification(String title, String desc, int time, int id,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        desc,
        tz.TZDateTime.now(tz.local).add(
          Duration(milliseconds: time),
        ),
        const NotificationDetails(
          android: AndroidNotificationDetails('medicines_id', 'medicines',
              channelDescription: 'medicines_notification_channel',
              importance: Importance.high,
              priority: Priority.high,
              color: Colors.cyan),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future removeNotify(int notifId,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    try {
      return await flutterLocalNotificationsPlugin.cancel(notifId);
    } catch (e) {
      return null;
    }
  }
}
