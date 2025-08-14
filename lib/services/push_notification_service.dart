import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mindfulminis/services/local_notifications.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  initToken() async {
    try {
      final granted = await _requestPermission();
      if (granted) {
        await _getAndSaveToken();
        await subscribeToTopics();
        _listenTokenRefresh();
        _setupMessageHandlers();
      }
    } catch (e, s) {
      log("❌ PushNotificationService init error: $e", stackTrace: s);
    }
  }

  /// Request Notification Permission
  Future<bool> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("✅ Notification permission granted");
      return true;
    } else {
      log("⚠️ Notification permission denied");
      return false;
    }
  }

  /// Get and Save Token
  Future<void> _getAndSaveToken() async {
    if (Platform.isIOS) {
      final apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken == null) {
        log("⚠️ APNS token not available yet");
        return;
      }
    }

    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      log("📲 FCM Token: $token");
    } else {
      log("⚠️ FCM token is null");
    }
  }

  /// Listen for token refresh
  void _listenTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      log("🔄 FCM Token refreshed: $newToken");
      // _userService.updateUserValues({'fcmToken': newToken});
    });
  }

  /// Setup Message Handlers
  void _setupMessageHandlers() {
    // Foreground notifications
    FirebaseMessaging.onMessage.listen((message) {
      log("📩 Foreground message: ${message.notification?.title}");
      final title = message.notification?.title ?? '';
      final body = message.notification?.body ?? '';
      final imageUrl = message.notification?.android?.imageUrl;

      if (Platform.isAndroid) {
        final imageUrl = message.notification?.android?.imageUrl;
        LocalNotificationService().showNotification(title, body, '', imageUrl);
      }
    });

    // App opened from terminated state
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    log("🔔 Notification tapped: ${message.data}");
    // TODO: Navigate to specific screen based on message.data
  }

  final String allUsersTopic = "all_users";

  /// Subscribe to topics for group notifications
  Future<void> subscribeToTopics() async {
    await _firebaseMessaging.subscribeToTopic(allUsersTopic);
    log("✅ Subscribed to topic: $allUsersTopic");

    // await _firebaseMessaging.subscribeToTopic("promotions");
  }
}
