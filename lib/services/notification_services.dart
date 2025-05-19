import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '/models/task.dart';
import '/ui/pages/notification_screen.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();
  cancelNotification(Task task) async {
    await flutterLocalNotificationsPlugin.cancel(task.id!);
  }

  displayNotification({required String title, required String body}) async {
    debugPrint('doing test');
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
    // await requestIOSPermissions(flutterLocalNotificationsPlugin);
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
          iOS: initializationSettingsIOS,
          android: initializationSettingsAndroid,
        );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) async {
        if (notificationResponse.payload != null) {
          debugPrint('notification payload: ${notificationResponse.payload}');
        }
        selectNotificationSubject.add(notificationResponse.payload!);
      },
    );
  }

  /*   Future selectNotification(String? payload) async {
    if (payload != null) {
      //selectedNotificationPayload = "The best";
      selectNotificationSubject.add(payload);
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => SecondScreen(selectedNotificationPayload));
  } */

  //Older IOS
  Future onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    // display a dialog with the notification details, tap ok to go to another page
    /* showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Title'),
        content: const Text('Body'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Container(color: Colors.white),
                ),
              );
            },
          )
        ],
      ),
    ); 
 */
    Get.dialog(Text(body!));
  }

  // Requests iOS-specific notification permissions.
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _nextInstanceOfTenAM(
        hour,
        minutes,
        task.remind!,
        task.repeat!,
        task.date!,
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      debugPrint('My payload is $payload');
      await Get.to(() => NotificationScreen(payload: payload));
    });
  }

  tz.TZDateTime _nextInstanceOfTenAM(
    int hour,
    int minutes,
    int remind,
    String repeat,
    String date,
  ) {
    var formatedDate = DateFormat.yMd().parse(date);
    tz.TZDateTime fd = tz.TZDateTime.from(formatedDate, tz.local);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      DateFormat.yMd().parse(date).day,
      fd.month,
      fd.day,
      fd.hour,
      fd.minute,
    );

    scheduledDate = _remind(remind, scheduledDate);

    if (scheduledDate.isBefore(now)) {
      if (repeat == 'Daily ') {
        scheduledDate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          DateFormat.yMd().parse(date).day + 1,
          hour,
          minutes,
        );
      }
      if (repeat == 'Weekly ') {
        scheduledDate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          DateFormat.yMd().parse(date).day + 7,
          hour,
          minutes,
        );
      }
      if (repeat == 'Monthly ') {
        scheduledDate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          DateFormat.yMd().parse(date).day + 30,
          hour,
          minutes,
        );
      }
      scheduledDate = _remind(remind, scheduledDate);
    }

    return scheduledDate;
  }

  tz.TZDateTime _remind(int remind, tz.TZDateTime scheduledDate) {
    if (remind == 5) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    }
    if (remind == 10) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
    }
    if (remind == 15) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 15));
    }
    if (remind == 20) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 20));
    }
    return scheduledDate;
  }
}
