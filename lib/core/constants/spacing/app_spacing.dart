import 'package:flutter/painting.dart';

class AppSpacing {
  AppSpacing._();

  // ─────────────────────────────
  // Spacing
  // ─────────────────────────────

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // ─────────────────────────────
  // Edge Insets
  // ─────────────────────────────

  static const horizontal = EdgeInsets.symmetric(horizontal: 16);
  static const vertical = EdgeInsets.symmetric(vertical: 16);
  static const all = EdgeInsets.all(16);

  static const horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const horizontalLg = EdgeInsets.symmetric(horizontal: lg);

  static const verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const verticalMd = EdgeInsets.symmetric(vertical: md);
  static const verticalLg = EdgeInsets.symmetric(vertical: lg);

  // ─────────────────────────────
  // Common screen padding
  // ─────────────────────────────

  static const screen = EdgeInsets.symmetric(horizontal: 16);
  static const double screenHorizontal = 16.0;
  static const double screenVertical = 8.0;

  static const screenSm = EdgeInsets.symmetric(horizontal: 8);
  static const screenLg = EdgeInsets.symmetric(horizontal: 24);
}
