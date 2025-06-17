import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mindfulminis/services/local_notifications.dart';

class PushNotificationService {
  initToken() async {
    try {
      //request the token
      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(sound: true);

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get the token each time the application loads

        if (Platform.isIOS) {
          // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
          final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          if (apnsToken != null) {
            String? token = await FirebaseMessaging.instance.getToken();

            // Save the initial token to the database
            // await apiService.updateUserToken(
            //   userId: currentUser.id!,
            //   token: token ?? "",
            // );
          }
        } else {
          String? token = await FirebaseMessaging.instance.getToken();
          log(token.toString());
          if (token != null) {
            // Save the initial token to the database
            // await apiService.updateUserToken(
            //   userId: currentUser.id!,
            //   token: token,
            // );
          }
        }
        // onMessage: When the app is open and it receives a push notification
        FirebaseMessaging.onMessage.listen((message) async {
          if (Platform.isAndroid) {
            LocalNotificationService().showNotification(
              message.notification?.title ?? "",
              message.notification?.body ?? "",
              '',
            );
          }
        });

        // Any time the token refreshes, store this in the database too.
        FirebaseMessaging.instance.onTokenRefresh.listen((token) {
          // apiService.updateUserToken(userId: currentUser.id!, token: token);
        });
        // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
        FirebaseMessaging.instance.getInitialMessage().then((
          RemoteMessage? message,
        ) {
          // if (message != null) {
          //   locator<NavigationService>().navigateTo(Routes.notificationsView);
          // }
        });

        // replacement for onResume: When the app is in the background and opened directly from the push notification.
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          // locator<NavigationService>().navigateTo(Routes.notificationsView);
        });
      }
    } catch (e) {
      log("Error initializing token state: $e");
    }
  }
}
