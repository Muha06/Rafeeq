import 'package:flutter/painting.dart';

class AppDarkColors {
  // BACKGROUND
  static const canvas = Color(0xFF0A0F14);
  static const surfaceLow = Color(0xFF0F161D); // Bottomsheets, dialogs

  // SURFACES
  static const surface = Color(0xFF131B23);
  static const surfaceHigh = Color(0xFF1B2733);
  static const surfaceHighest = Color(0xFF2A3A48);

  // BORDERS / DIVIDERS (tinted navy, subtler)
  static const outline = Color(0xFF26323D);
  static const outlineVariant = Color(0xFF334250);

  // PRIMARY || SECONDARY || TERTIARY
  static const primary = Color(0xFF3FB1C0); // lighter teal: readable on dark
  static const secondary = Color(0xFFA7B3BC);
  static const tertiary = Color(0xFFE3B866); // gold, replaces lime

  // ON P | S | T
  static const onPrimary = Color(0xFF04242A);
  static const onSecondary = Color(0xFF1E252D);
  static const onTertiary = Color(0xFF2A1D08);

  // CONTAINERS
  static const primaryContainer = Color(0xFF1E4750);
  static const secondaryContainer = Color(0xFF2F3A44);
  static const tertiaryContainer = Color(0xFF3D3116); // dark gold-brown

  // ON CONTAINERS
  static const onPrimaryContainer = Color(0xFFD3FAF9);
  static const onSecondaryContainer = Color(0xFFDCE2E6);
  static const onTertiaryContainer = Color(0xFFF6E8C8);

  // ON SURFACES
  static const onSurface = Color(0xFFEEF2F4);
  static const onSurface2 = Color(0xFF8CA3B2); // secondary text, ~6.5:1

  // ERROR
  static const error = Color(0xFFE07A7A);
  static const onError = Color(0xFF3B0A0A);
  static const errorContainer = Color(0xFF4A2020);
  static const onErrorContainer = Color(0xFFF9DEDC);

  // SHADOW
  static const shadow = Color(0x66000000);
  static const scrim = Color(0x99000000);

  // SWITCH
  static const switchOn = primary;
  static const switchBg = Color(0xFF35434A);
  static const switchRipple = Color(0x1A9FC4C8);
}
