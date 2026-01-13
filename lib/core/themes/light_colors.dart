import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

// ==== Light Theme ====
class AppLightColors {
  // ☀️ Light theme background
  static const Color lightBackground = Color(
    0xFFF1F3F6,
  ); // soft off-white, not pure white

  // 🧱 Surfaces (cards, sheets, dialogs)
  static const Color lightSurface = Color(
    0xfffafafa,
  ); // clean white for contrast & readability

  // 🟡 Accent (same as dark → brand consistency)
  static const Color amber = Color(0xFFFFC36A);

  // 📝 Text colors
  static const Color textPrimary = Color(
    0xFF111827,
  ); // Qur’an text – deep charcoal (not pure black)

  static const Color textBody = Color(
    0xFF1F2937,
  ); // translations / body text – softer than primary

  static const Color textSecondary = Color(
    0xFF6B7280,
  ); // metadata, ayah numbers, hints

  // 🔘 Buttons & interactive elements
  static const Color buttonPrimary = amber;
  static const Color buttonSecondary = Color(0xFFE5E7EB); // subtle gray buttons
  static const Color buttonDisabled = Color(0xFFCBD5E1);

  // ⚠️ Feedback
  static const Color errorColor = Color(0xFFDC2626); // red but not aggressive
  static const Color successColor = Color(0xFF16A34A); // calm green
  static const Color warningColor = amber;

  // ─ Borders / Dividers
  static Color divider = const Color(0xFF1F2937).withAlpha(40);
  static const Color border = Color(0xFF1F2937);

  //icon colors
  static const Color iconPrimary = textPrimary;
  static const Color iconSecondary = textSecondary;
  static const Color iconDisabled = Color(0xFF9CA3AF);
  static const Color iconAccent = AppLightColors.amber; //selected index
  static const Color iconSuccess = Color(0xFF16A34A);

  static Color selectedBottomBar = Colors.grey[300]!; //bottom bar selected bg
}
