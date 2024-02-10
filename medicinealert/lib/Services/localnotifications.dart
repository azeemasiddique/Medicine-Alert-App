import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    tz.initializeTimeZones();
    var androidInitialize = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = new DarwinInitializationSettings();
    var initializationsSettings =
    new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required TimeOfDay scheduledTime,
    required String repeatDaily,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'ReminderApp',
      'channel_name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
      ongoing: false,
      actions: [
        AndroidNotificationAction(
          'notification_action',
          'View Reminder',
        ),
      ],
    );

    var notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),

    );

    final now = DateTime.now();
    final scheduledDateTime = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    if (repeatDaily == 'Yes') {
      print('yes');
      setDailyNotification(id: id, title: title, body: body, payload: id.toString(),  time: TimeOfDay(hour: scheduledTime.hour, minute: scheduledTime.minute), repeatDaily: 'Yes');

      // setDailyNotification(id: id, title: title, body: body, payload: id.toString(),  time: TimeOfDay(hour: scheduledTime.hour, minute: scheduledTime.minute).toDateTime(),);
      // while (scheduledDateTime.isBefore(now)) {
      //   scheduledDateTime.add(Duration(days: 1)); // Move to next day if in the past
      // }
    }

    if (scheduledDateTime.isAfter(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: id.toString(),
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static DateTime convertTimeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  static Location get location {
    DateTime nowTime = DateTime.now();
    Location location = Location(
      nowTime.timeZoneName,
      [minTime],
      [0],
      [
        TimeZone(
          nowTime.timeZoneOffset.inMilliseconds,
          isDst: false,
          abbreviation: nowTime.timeZoneName,
        ),
      ],
    );
    return location;
  }

  static NotificationDetails get platformChannelSpecifics {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'reminders',
      'Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );
    DarwinNotificationDetails iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    return NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  }
  // Set daily notification
  static Future<void> setDailyNotification({
    required int id,
    required String? title,
    required String? body,
    required String? payload,
    required TimeOfDay time,
    required String repeatDaily,
  }) async {

    final notificationTime = convertTimeOfDayToDateTime(time);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(time , repeatDaily),
      platformChannelSpecifics,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(TimeOfDay time,String repeatDaily) {
    final now = tz.TZDateTime.now(location);

    if (repeatDaily == 'Yes') {
      var scheduledDate = tz.TZDateTime(location, now.year, now.month, now.day, time.hour, time.minute);

      // If the scheduled time is before the current time, move it to the next day
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      return scheduledDate;
    } else {
      return tz.TZDateTime(location, now.year, now.month, now.day, time.hour, time.minute);
    }
  }

}
