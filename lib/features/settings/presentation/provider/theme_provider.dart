import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

enum AppThemeMode { system, light, dark }

final themeModeProvider = StateProvider<AppThemeMode>(
  (ref) => AppThemeMode.dark,
);

//provider that listens when user changes phone theme
final platformBrightnessProvider = Provider<Brightness>((ref) {
  final dispatcher = WidgetsBinding.instance.platformDispatcher;

  ref.onDispose(() {
    dispatcher.onPlatformBrightnessChanged = null;
  });

  dispatcher.onPlatformBrightnessChanged = () {
    ref.invalidateSelf();
  };

  return dispatcher.platformBrightness;
});

final isDarkProvider = Provider<bool>((ref) {
  final currentMode = ref.watch(themeModeProvider);
  if (currentMode == AppThemeMode.dark) return true;
  if (currentMode == AppThemeMode.light) return false;

  // System mode
  final brightness = ref.watch(platformBrightnessProvider);

  return brightness == Brightness.dark;
});
