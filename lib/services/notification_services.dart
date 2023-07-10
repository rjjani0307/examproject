import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/task.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> selectedNotificationSubject =
      BehaviorSubject<String?>();

  //

//   initializeNotification() async {
//     tz.initializeTimeZones();
//     // await _configureLocalTimeZone();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
// final DarwinInitializationSettings initializationSettingsIOS =
// DarwinInitializationSettings(
//         // onDidReceiveLocalNotification: onDidReceiveLocalNotification
// );
// // final MacOSInitializationSettings initializationSettingsMacOS =
// //     MacOSInitializationSettings();
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: initializationSettingsAndroid,
//       // iOS: initializationSettingsIOS,
//       // macOS: initializationSettingsMacOS
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (data) async {
//           if (data != null) {
//             debugPrint("notification payload:" + data.payload!);
//           }
//           selectedNotificationSubject.add(data.payload);
//         }
//     );
//   }

  // Future<void> _configureLocalTimeZone() async {
  //   tz.initializeTimeZones();
  //   //final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
  //   tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
  // }

  initializeNotification() async {
    _configureLocalTimeZone(); // this is for latest iOS settings
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("appicon");

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (data) async {
      if (data != null) {
        debugPrint("notification payload:" + data.payload!);
      }
      selectedNotificationSubject.add(data.payload);
    });
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }

    if(payload == "Theme changed"){
      print("Nothing no navigate to");
    }else {
      Get.to(() => Container());
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   //context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
    Get.dialog(Text("Welcome to flutter"));
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  displayNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: title);
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        task.title,
        task.note,
        _convertTime(hour, minutes),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
        )),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title}|"+"${task.note}|"
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDAte =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    if (scheduleDAte.isBefore(now)) {
      scheduleDAte = scheduleDAte.add(Duration(days: 1));
    }
    return scheduleDAte;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timezone = await FlutterNativeTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(timezone));
  }
}
