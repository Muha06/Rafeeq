import 'package:flutter/material.dart';

class AppColors {
  // 🌑 Dark theme bg (default)
  // Background stays ultra-dark
  static const Color darkBackground = Color(
    0xFF020A17,
  ); // deep navy, almost black

  // Lighter surface for cards, sheets, etc.
  static const Color darkSurface = Color(
    0xFF06122B,
  ); // richer, slightly brighter dark blue

  // 🟡 Accent – soft amber
  static const Color amber = Color(0xFFFFC36A);

  // 📝 Text colors
  static const Color textPrimary = Color(0xFFEDEDED); // Qur’an text, brighter

  static const Color textBody = Colors.white; // normal body, slightly darker

  static const Color textSecondary = Color(
    0xFFB3B3B3,
  ); // metadata, ayah numbers

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
