import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/core/app_keys.dart';
import 'package:rafeeq/features/notifications/data/datasources/app_notifications_remote_ds.dart';
import 'package:rafeeq/features/notifications/presentation/pages/notif_details_page.dart';

const _boxName = 'settingsBox';
const _fcmTokenKey = 'fcm_token';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationRemoteDataSource notificationRemoteDataSource;

  PushNotificationService({required this.notificationRemoteDataSource});

  /// Call this from main() after Firebase.initializeApp()
  Future<void> init() async {
    await _requestPermission(); //Permissions
    await _getAndStoreToken(); //Token

    _handleForegroundMessages();
    _handleNotificationTap();
    await _handleInitialMessage();
    _handleTokenRefresh();
  }

  Future<void> _saveToken(String token) async {
    try {
      await notificationRemoteDataSource.saveToken(token);
    } catch (e) {
      debugPrint("Error saving token: $e");
    }
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
    try {
      final token = await _messaging.getToken();

      if (token == null) return;

      final storedToken = _getStoredToken();

      if (storedToken == token) {
        debugPrint("✅ Token unchanged, skipping save");
        return;
      }

      debugPrint("🆕 New token detected, saving...");

      await _saveToken(token);
      await _storeTokenLocally(token);
    } catch (e) {
      debugPrint("⚠️ Failed to get FCM token (likely offline): $e");

      //retry later instead of crashing flow
      Future.delayed(const Duration(seconds: 5), () {
        _retryTokenFetch();
      });
    }
  }

  //Retry fetch token
  Future<void> _retryTokenFetch() async {
    try {
      final token = await _messaging.getToken();

      if (token == null) return;

      final storedToken = _getStoredToken();

      if (storedToken != token) {
        await _saveToken(token);
        await _storeTokenLocally(token);
      }
    } catch (e) {
      debugPrint("🔁 Retry failed again: $e");
    }
  }

  // -------------------------
  // 3. Foreground messages (When app is open)
  // -------------------------
  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground message: ${message.notification?.title}");

      final title = message.notification?.title ?? "New notification";

      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text(title)),
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
    _messaging.onTokenRefresh.listen((newToken) async {
      try {
        debugPrint("🔄 New FCM token: $newToken");

        final storedToken = _getStoredToken();

        if (storedToken != newToken) {
          await _saveToken(newToken);
          await _storeTokenLocally(newToken);
        }
      } catch (e) {
        debugPrint("Token refresh error: $e");
      }
    });
  }

  // -------------------------
  // 7. Navigation logic
  // -------------------------
  void _navigateFromMessage(RemoteMessage message) {
    final data = message.data;

    final notificationId = data['notification_id'];

    if (notificationId == null) return;

    //Pushing to Notification details page
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => NotificationDetailPage(notificationId: notificationId),
      ),
    );
  }

  Box get _box => Hive.box(_boxName);

  String? _getStoredToken() {
    return _box.get(_fcmTokenKey);
  }

  Future<void> _storeTokenLocally(String token) async {
    await _box.put(_fcmTokenKey, token);
  }
}
