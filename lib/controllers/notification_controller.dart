import 'package:advanced_todo_app/ui/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../modules/task.dart';

class NotificationController {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNoification() async {
    tz.initializeTimeZones();
    // tz.setLocalLocation(tz.getLocation(timeZoneName));
    final AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('appicon');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload##########: $payload');
    }
    await Get.to(() => NotificationScreen(payload: payload!));
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Get.dialog(Text(body!));
  }

  displayNotification({
    required String title,
    required String body,
  }) {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails,
        payload: 'default sound ');
  }

  scheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled notification',
        'scheduled notification',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  cancelNotification(Task task) {
    flutterLocalNotificationsPlugin.cancel(task.id!);
    print('Task is canceled successfully');
  }

  cancelAllNotification() {
    flutterLocalNotificationsPlugin.cancelAll();
    print(' All Tasks is canceled successfully');
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _nextInstanceOfTenAM(hour, minutes, task),
      const NotificationDetails(
        android:
            AndroidNotificationDetails('your channel id', 'your channel name'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour, int minutes, Task task) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    var formattedDate = DateFormat.yMd().parse(task.date!);
    final tz.TZDateTime fd = tz.TZDateTime.from(formattedDate, tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, fd.year, fd.month, fd.day, hour, minutes);

    scheduledDate = prepareReminder(task.remaind!, scheduledDate);
    if (scheduledDate.isBefore(now)) {
      if (task.repeat == 'Daily') {
        scheduledDate = tz.TZDateTime(tz.local, formattedDate.year,
            formattedDate.month, formattedDate.day + 1, hour, minutes);
      } else if (task.repeat == 'Weekly') {
        scheduledDate = tz.TZDateTime(tz.local, formattedDate.year,
            formattedDate.month, formattedDate.day + 7, hour, minutes);
      } else if (task.repeat == 'Monthly') {
        scheduledDate = tz.TZDateTime(tz.local, formattedDate.year,
            formattedDate.month + 1, formattedDate.day, hour, minutes);
      }
      scheduledDate = prepareReminder(task.remaind!, scheduledDate);
    }
    print('scheduledDate ###########is $scheduledDate');
    return scheduledDate;
  }

  tz.TZDateTime prepareReminder(int remind, tz.TZDateTime scheduledDate) {
    if (remind == 5) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    } else if (remind == 10) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
    } else if (remind == 15) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 15));
    } else if (remind == 20) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 20));
    }
    return scheduledDate;
  }
}
