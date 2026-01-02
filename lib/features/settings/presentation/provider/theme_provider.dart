import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

enum AppThemeMode { system, light, dark }

final themeModeProvider = StateProvider<AppThemeMode>(
  (ref) => AppThemeMode.system,
);

final isDarkProvider = Provider<bool>((ref) {
  final currentMode = ref.watch(themeModeProvider);
  if (currentMode == AppThemeMode.dark) return true;
  if (currentMode == AppThemeMode.light) return false;

  // System mode
  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  return brightness == Brightness.dark;
});
