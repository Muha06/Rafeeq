import 'package:flutter/widgets.dart';
import 'package:vibration/vibration.dart';

class AppHaptics {
  AppHaptics._();

  static Future<bool> _canVibrate() async {
    return await Vibration.hasVibrator();
  }

  static Future<void> selection() async {
    if (!await _canVibrate()) return;

    Vibration.vibrate(duration: 20);
  }

  static Future<void> light() async {
    if (!await _canVibrate()) return;

    Vibration.vibrate(duration: 30);
  }

  static Future<void> medium() async {
    if (!await _canVibrate()) return;

    Vibration.vibrate(duration: 50);
  }

  static Future<void> heavy() async {
    if (!await _canVibrate()) return;

    Vibration.vibrate(duration: 80);
  }

  static Future<void> success() async {
    if (!await _canVibrate()) return;

    Vibration.vibrate(pattern: [0, 30, 40, 30]);
  }

  static Future<void> warning() async {
    if (!await _canVibrate()) return;

    Vibration.vibrate(pattern: [0, 80, 50, 80]);
  }

  static Future<void> error() async {
    if (!await _canVibrate()) return;

    Vibration.vibrate(pattern: [0, 120, 60, 120]);
  }

  static Future<void> longPress() async {
    if (!await _canVibrate()) return;

    Vibration.vibrate(duration: 60);
  }

  static Future<void> custom({
    int duration = 40,
    List<int>? pattern,
    int amplitude = -1,
  }) async {
    if (!await _canVibrate()) return;

    if (pattern != null) {
      await Vibration.vibrate(pattern: pattern, amplitude: amplitude);
    } else {
      await Vibration.vibrate(duration: duration, amplitude: amplitude);
    }
  }
}
