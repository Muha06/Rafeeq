import 'package:flutter/material.dart';

class AppColors {
  // 🌑 Dark theme bg (default)
  static const Color darkBackground = Color(0xFF0B0C10);
  static const Color darkSurface = Color(0xFF1B1F26);

  // 🟡 Accent – soft amber
  static const Color amber = Color(0xFFFFC36A);

  // 📝 Text colors
  static const Color textPrimary = Color(
    0xFFEDEDED,
  ); // Qur’an text – bright enough against darkSurface
  static const Color textBody = Color(
    0xFFD9D9D9,
  ); // normal body text – slightly softer than primary
  static const Color textSecondary = Color(
    0xFF9CA3AF,
  ); // metadata, ayah numbers – muted but readable

  // ==== Light Theme ====
  //background color
  static const Color lightBackground = Color(0xFFF4F6F8);

  //light surface
  static const Color lightSurface = Color.fromARGB(130, 255, 238, 203);

  //light theme text colors
  static const Color lightTextPrimary = Colors.black; //Quran
  static const Color lightTextBody = Colors.black; //translations
  static const Color lightTextSecondary = Color(0xFF6B7A86);
}
