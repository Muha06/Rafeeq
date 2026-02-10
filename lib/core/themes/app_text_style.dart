import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Use ONE Latin font for the whole UI
  static TextStyle get _base => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    height: 1.35,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w400,
  );

  // AppBar / page titles (not screaming)
  static TextStyle get title => _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.0,
  );

  // Section headers: "Today", "Explore", "Daily verse"
  static TextStyle get section => _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.1,
  );

  // Normal UI body (most text)
  static TextStyle get body =>
      _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.45);

  // Longer paragraphs (verse translations / descriptions)
  static TextStyle get paragraph =>
      _base.copyWith(fontSize: 14, height: 1.6, letterSpacing: 0.15);

  // Captions / secondary
  static TextStyle get secondary => _base.copyWith(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: 0.2,
  );

  // Tiny labels (times, chips, "Tap to read")
  static TextStyle get label => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.1,
  );

  // Qur'an Arabic (keep your Uthmani)
  static const TextStyle quranBody = TextStyle(
    fontFamily: 'Uthmani',
    fontSize: 30,
    height: 1.85,
    wordSpacing: 2,
    fontFamilyFallback: ['NotoNaskhArabic', 'Amiri'],
  );

  // General Arabic UI text (not Qur’an script)
  static TextStyle get arabicUi => const TextStyle(
    fontFamily: 'NotoKufiArabic',
    fontSize: 16,
    height: 1.4,
    fontWeight: FontWeight.w500,
  );
}
