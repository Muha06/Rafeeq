import 'package:flutter/material.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';

class AppTextTheme {
  AppTextTheme._();

  static const String primaryFont = AppStrings.primaryFont;
  static const String displayFont = AppStrings.displayFont;

  static TextTheme build(ColorScheme colors) {
    return TextTheme(
      // ─────────────────────────────────────────────
      // HEADINGS
      // ─────────────────────────────────────────────

      headlineSmall: TextStyle(
        fontFamily: displayFont,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: colors.onSurface,
      ),

      titleLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: colors.onSurface,
      ),

      titleMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),

      // ─────────────────────────────────────────────
      // UI TEXT
      // ─────────────────────────────────────────────
      labelLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: colors.onSurface,
      ),

      labelMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),

      labelSmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.onSurfaceVariant,
      ),

      // ─────────────────────────────────────────────
      // LONG-FORM CONTENT
      // ─────────────────────────────────────────────
      bodyLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.65,
        color: colors.onSurface,
      ),

      bodyMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.65,
        color: colors.onSurfaceVariant,
      ),
    );
  }
}
