import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  int notificationId = 0;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  init() {
    var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@drawable/noti',
    );
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
    String notificationTitle,
    String notificationContent,
    String payload,
    String? url, {
    String channelId = 'high_importance_channel',
    String channelTitle = 'High Importance Notifications',
    String channelDescription =
        'This channel is used for important notifications.',
    Priority notificationPriority = Priority.high,
    Importance notificationImportance = Importance.max,
  }) async {
    BigPictureStyleInformation? bigPictureStyleInformation;
    if (url != null) {
      final response = await http.get(Uri.parse(url));
      bigPictureStyleInformation = BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(
          base64Encode(response.bodyBytes),
        ),
      );
    }
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription: channelDescription,
      playSound: false,
      importance: notificationImportance,
      priority: notificationPriority,
      icon: "@drawable/noti",
      ticker: 'ticker',
      styleInformation: bigPictureStyleInformation,
    );
    // var iOSPlatformChannelSpecifics =
    //     IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Future<dynamic> onSelectNotification(String payload) async {
  //   locator<NavigationService>().navigateTo(Routes.notificationsView);
  // }
}
