import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class RafeeqAnalytics {
  // Singleton instance
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // -------------------------
  // Log screen views
  // -------------------------
  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // -------------------------
  // Log feature usage events
  // -------------------------
  static Future<void> logFeature(
    String featureName, {
    Map<String, Object>? parameters,
  }) async {
    debugPrint("logging feature");
    try {
      await _analytics.logEvent(name: featureName, parameters: parameters);
    } catch (e) {
      debugPrint("Error logging feature $e");
    }
  }

  // -------------------------
  // Log first open / install
  // -------------------------
  static Future<void> logFirstOpen() async {
    await _analytics.logEvent(
      name: 'first_open_custom',
      parameters: {'timestamp': DateTime.now().toIso8601String()},
    );
  }

  // -------------------------
  // Set user properties
  // -------------------------
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
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

  // -------------------------
  // Optional: log custom timed events
  // -------------------------
  static Future<void> logTimedEvent(
    String name,
    Duration duration, {
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: {
        'duration_ms': duration.inMilliseconds,
        if (parameters != null) ...parameters,
      },
    );
  }
}
