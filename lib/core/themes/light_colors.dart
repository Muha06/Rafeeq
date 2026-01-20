import 'package:flutter/material.dart';

// ==== Light Theme ====
class AppLightColors {
  // Background (warm paper)
  static const Color lightBackground = Color(0xFFF8F2EA);

  // Surface (cards/sheets) - slightly lighter than bg
  static const Color lightSurface = amberSoft;
  // static const Color lightSurface2 = amberSoft;

  // Surface 2 (chips/sections/containers)
  static const Color lightSurface2 = Color(0xFFF2E6D8);

  // Primary (cocoa brown)
  static const Color primary = Color(0xFF7A5A45);

  // Primary pressed / darker
  static const Color primaryDark = Color(0xFF5E4333);

  // Soft highlight (selected tab / selected bottom nav bg)
  static const Color primarySoft = Color(0x267A5A45); // ~15%

  // Accent (your amber for tiny highlights if needed)
  static const Color amber = Color(0xFFFFC36A);
  static const Color amberSoft = Color(0x26FFC36A);

  // Text
  static const Color textPrimary = Color(0xFF1F1A17);
  static const Color textBody = Color(0xFF2F2722);
  static const Color textSecondary = Color(0xFF7A6F67);

  // Icons
  static const Color iconPrimary = textPrimary;
  static const Color iconSecondary = textSecondary;
  static const Color iconAccent = primary;

  // Dividers / borders (warm, subtle)
  static const Color divider = Color(0xFFD8CABB);
  static const Color border = Color(0xFFE6D9CC);

  // Selected bottom bar bg
  static const Color selectedBottomBar = Color(0x1A7A5A45); // ~10%

  // ✅ Buttons (Warm Paper theme)
  static const Color buttonPrimary = AppLightColors.primary; // cocoa
  static const Color buttonPrimaryText = Color(0xFFFFF8F1); // paper-white
  static const Color buttonPrimaryPressed =
      AppLightColors.primaryDark; // darker cocoa
  static const Color buttonPrimaryDisabled = Color(0xFFC9B9AE); // warm gray

  static const Color buttonSecondary = AppLightColors.lightSurface; // paper
  static const Color buttonSecondaryText = AppLightColors.primary; // cocoa text
  static const Color buttonSecondaryBorder = Color(0xFFD8CABB); // warm border
  static const Color buttonSecondaryPressed = AppLightColors.lightSurface2;

  static const Color buttonTertiaryText = AppLightColors.primary; // text-only

  // Optional: small highlight button (use sparingly)
  static const Color buttonAccent = AppLightColors.amber; // your amber
  static const Color buttonAccentText = Color(0xFF1F1A17);

  //-------SNACKBAR COLORS-----------------------
  static const snackbarText = Color(0xFFFFF8F1);
  static const snackbarActionbutton = Color(0xFFFFC36A);

  static const snackbarSuccessBg = Color(0xFF2F6B4F);
  static const snackbarErrorBg = Color(0xFF8B2E3A);
  static const snackbarWarningBg = Color(0xFF8A5A1E);
  static const snackbarInfoBg = Color(0xFF3B2F28);

  //-------switch----------
  // ON
  static const Color switchTrackOn = Color(0x267A5A45); // cocoa @ ~15%
  static const Color switchThumbOn = Color(0xFF7A5A45); // cocoa
  static const Color switchOutlineOn = Color(0x1F7A5A45); // cocoa @ ~12%

  // OFF
  static const Color switchTrackOff = Color(0xFFD8CABB); // warm divider
  static const Color switchThumbOff = Color(0xFFF2E6D8); // surface2
  static const Color switchOutlineOff = Color(0xFFE6D9CC); // border
}
