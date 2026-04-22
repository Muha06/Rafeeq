import 'package:flutter/material.dart';
import 'package:rafeeq/core/themes/dark_theme.dart';

class AppTextStyles {
  // Qur'an Arabic
  static const TextStyle quranAyah = TextStyle(
    fontFamily: 'Uthmani2',
    fontSize: 24,
    height: 1.9,
    wordSpacing: 3,
    fontWeight: FontWeight.w300,
    color: AppDarkColors.onSurface,
    fontFamilyFallback: ['NotoNaskhArabic', 'Amiri'],
  );

  // Arabic UI (non-Qur'an)
  static TextStyle get arabicUi => const TextStyle(
    fontFamily: 'Uthmani',
    fontSize: 24,
    height: 1.6,
    wordSpacing: 2.5,
    color: AppDarkColors.onSurface,
    fontWeight: FontWeight.w300,
  );
}
