import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around Firebase Cloud Messaging: requests notification
/// permission and logs the device token/foreground messages. Wire the token
/// to a backend "register device" call once one exists.
///
/// iOS Simulators don't support real APNs delivery, and even on a real
/// device the APNs token can take a moment to arrive after permission is
/// granted, so `getToken()` (which needs it first) is allowed to fail here
/// without crashing app startup.
class PushNotificationService {
  final FirebaseMessaging _messaging;

  PushNotificationService([FirebaseMessaging? messaging])
      : _messaging = messaging ?? FirebaseMessaging.instance;

  Future<void> init() async {
    try {
      final settings = await _messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return;
      }

      if (Platform.isIOS) {
        await _waitForApnsToken();
      }

      final token = await _messaging.getToken();
      if (kDebugMode) {
        debugPrint('FCM token: $token');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Push notification setup skipped: $e');
      }
      return;
    }

    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        debugPrint('Foreground FCM message: ${message.notification?.title}');
      }
    });
  }

  Future<void> _waitForApnsToken() async {
    for (var attempt = 0; attempt < 5; attempt++) {
      if (await _messaging.getAPNSToken() != null) return;
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
