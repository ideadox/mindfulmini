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
    String payload, {
    String channelId = 'high_importance_channel',
    String channelTitle = 'High Importance Notifications',
    String channelDescription =
        'This channel is used for important notifications.',
    Priority notificationPriority = Priority.high,
    Importance notificationImportance = Importance.max,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription: channelDescription,
      playSound: false,
      importance: notificationImportance,
      priority: notificationPriority,
      icon: "@drawable/noti",
      ticker: 'ticker',
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
