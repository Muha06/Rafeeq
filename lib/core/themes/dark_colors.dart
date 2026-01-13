import 'package:flutter/material.dart';

class AppDarkColors {
  // 🌑 Dark theme bg (default)
  static const Color darkBackground = Color(0xFF0F0F0F); // main app background
  static const Color darkSurface = Color(
    0xFF1A1A1A,
  ); // slightly darker/lighter for cards/dialogs

  // 🟡 Accent
  static const Color amber = Color(
    0xFFFFC36A,
  ); // buttons, highlights, selected states

  // 📝 Text colors
  static const Color textPrimary = Color(
    0xFFEDEDED,
  ); // Qur’an text – bright enough
  static const Color textBody = Color(0xFFD9D9D9); // body text – softer
  static const Color textSecondary = Color(
    0xFF9CA3AF,
  ); // metadata, ayah numbers, muted

  // 🔹 Buttons & interactive elements
  static const Color buttonPrimary = amber; // main call-to-action buttons
  static const Color buttonSecondary = Color(
    0xFF2C2C2C,
  ); // secondary buttons (dark gray)
  static const Color buttonDisabled = Color(
    0xFF3A3A3A,
  ); // disabled state buttons

  // ⚠️ Feedback
  static const Color errorColor = Color(0xFFE04F5F); // validation errors
  static const Color successColor = Color(0xFF4BB543); // success indicators
  static const Color warningColor = amber; // warnings / highlights

  // 🌑 Borders / Dividers
  static const Color divider = Color(0xFF2C2C2C); // subtle separation lines
  static const Color border = Color(0xFF3A3A3A); // card or input borders

  // ⚡ Icon colors
  static const Color iconPrimary = textPrimary; // main icons, app bar, actions
  static const Color iconSecondary = textSecondary; // metadata, subtle actions
  static const Color iconDisabled =
      textSecondary; // use .withOpacity(0.5) when needed
  static const Color iconAccent = amber; // selected / active icons
  static Color selectedBottomBar = Colors.grey[800]!; //bottom bar selected bg
  static const Color iconError = Color(0xFFDC2626);
  static const Color iconSuccess = Color(0xFF16A34A);
  static const Color iconWarning = amber;
}
