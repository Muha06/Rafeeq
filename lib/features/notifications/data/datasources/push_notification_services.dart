import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rafeeq/core/app_keys.dart';
import 'package:rafeeq/features/notifications/presentation/pages/notif_details_page.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Call this from main() after Firebase.initializeApp()
  Future<void> init() async {
    await _requestPermission(); //Permissions
    await _getAndStoreToken(); //Token

    _handleForegroundMessages();
    _handleNotificationTap();
    await _handleInitialMessage();
    _handleTokenRefresh();
  }

  // -------------------------
  // 1. Permission
  // -------------------------
  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      criticalAlert: true,
      badge: true,
      sound: true,
    );
  }

  // -------------------------
  // 2. Token
  // -------------------------
  Future<void> _getAndStoreToken() async {
    final token = await _messaging.getToken();
    debugPrint("🔥 FCM TOKEN: $token");

    // TODO: send token to Supabase
  }

  // -------------------------
  // 3. Foreground messages (When app is open)
  // -------------------------
  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground message: ${message.notification?.title}");

      // Optional: show in-app snackbar/dialog here later
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('New notification received: $message')),
      );
    });
  }

  // -------------------------
  // 4. Notification tap (app in background)
  // -------------------------
  void _handleNotificationTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📲 Notification tapped");

      _navigateFromMessage(message);
    });
  }

  // -------------------------
  // 5. Cold start (app opened from terminated state)
  // -------------------------
  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();

    if (message != null) {
      debugPrint("🚀 App opened from notification");

      _navigateFromMessage(message);
    }
  }

  // -------------------------
  // 6. Token refresh (important)
  // -------------------------
  void _handleTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint("🔄 New FCM token: $newToken");

      // TODO: update Supabase
    });
  }

  // -------------------------
  // 7. Navigation logic
  // -------------------------
  void _navigateFromMessage(RemoteMessage message) {
    final data = message.data;

    final notificationId = data['notification_id'];

    if (notificationId == null) return;

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => NotificationDetailPage(notificationId: notificationId),
      ),
    );
  }
}
