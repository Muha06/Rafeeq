import 'package:flutter/material.dart';
import 'package:rafeeq/core/themes/dark_theme.dart';

class AppTextStyles {
  // Base Manrope style
  static const TextStyle _base = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    height: 1.35,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w400,
  );

  // AppBar / page titles
  static TextStyle get title => _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.0,
  );

  // Section headers
  static TextStyle get section => _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.1,
  );

  // Normal body text
  static TextStyle get body =>
      _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.45);

  // Longer paragraphs
  static TextStyle get paragraph =>
      _base.copyWith(fontSize: 14, height: 1.6, letterSpacing: 0.15);

  // Secondary / captions
  static TextStyle get secondary => _base.copyWith(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: 0.2,
  );

  // Labels
  static TextStyle get label => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.1,
  );

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
