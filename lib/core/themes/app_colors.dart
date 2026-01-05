import 'package:flutter/material.dart';

class AppColors {
  // 🌑 Dark theme bg (default)
  static const Color darkBackground = Color(0xFF010B13);

  // Slightly lighter surface for cards, sheets, etc.
  static const Color darkSurface = Color(0xFF0A1620);

  // 🟡 Accent – soft amber
  static const Color amber = Color(0xFFFFC36A);

  // 📝 Text colors
  static const Color textPrimary = Color(0xFFEDEDED); // Qur’an text, brighter
  static const Color textBody = Color(
    0xFFAAAAAA,
  ); // normal body, slightly darker
  static const Color textSecondary = Color(
    0xFFB3B3B3,
  ); // metadata, ayah numbers

  // ==== Light Theme ====
  //background color
  static const Color lightBackground = Color(0xFFF4F6F8);

  //light surface
  static const Color lightSurface = Color(0xFFFFFBF5);

  //light theme text colors
  static const Color lightTextPrimary = Color(0xFF0B1A24);
  static const Color lightTextBody = Color(0xFF3A4A56); // slightly muted
  static const Color lightTextSecondary = Color(0xFF6B7A86); // muted metadata
}
