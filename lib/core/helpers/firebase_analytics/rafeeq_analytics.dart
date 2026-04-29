import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class RafeeqAnalytics {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // -------------------------
  // Log screen views
  // -------------------------
  static Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
      debugPrint('Logging screen view');
    } catch (e) {
      debugPrint('Error logging screen view');
    }
  }

  // -------------------------
  // Log feature usage events
  // -------------------------
  static Future<void> logFeature(
    String featureName, {
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: featureName, parameters: parameters);
      debugPrint("logging feature");
    } catch (e) {
      debugPrint("Error logging feature $e");
    }
  }

  // -------------------------
  // Log first open / install
  // -------------------------
  static Future<void> logFirstOpen() async {
    await _analytics.logEvent(
      name: 'first_app_open_custom',
      parameters: {'timestamp': DateTime.now().toIso8601String()},
    );
  }

  // -------------------------
  // Optional: log errors
  // -------------------------
  static Future<void> logError(String error, {StackTrace? stack}) async {
    await _analytics.logEvent(
      name: 'error',
      parameters: {
        'error': error,
        if (stack != null) 'stack': stack.toString(),
      },
    );
  }
}
