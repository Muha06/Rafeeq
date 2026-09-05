import 'package:flutter/painting.dart';

class AppDarkColors {
  // BACKGROUND

  static const canvas = Color(0xFF0A0F14);
  static const surfaceLow = Color(0xFF111820); // Bottomsheets, dialogs

  // SURFACES

  static const surface = Color(0xFF1A222A);
  static const surfaceHigh = Color(0xFF333B48);
  static const surfaceHighest = Color(0xFF424B58);

  // BORDERS / DIVIDERS

  static const outline = Color(0xFF3A444C);
  static const outlineVariant = Color(0xFF3F4952);

  // PRIMARY || SECONDARY || TERTIARY

  static const primary = Color(0xFF1D7382);
  static const secondary = Color(0xFFA7B3BC);
  static const tertiary = Color(0xFFA4DF3F); // Special accent (Used sparingly)

  // ON P | S | T

  static const onPrimary = Color(0xFFFFFFFF);
  static const onSecondary = Color(0xFF1E252D);
  static const onTertiary = Color(0xFF1E252D);

  // CONTAINERS

  static const primaryContainer = Color(0xFF274A50);
  static const secondaryContainer = Color(0xFF343E46);
  static const tertiaryContainer = Color(0xFF35491F);

  // ON CONTAINERS

  static const onPrimaryContainer = Color(0xFFD3FAF9);
  static const onSecondaryContainer = Color(0xFFDCE2E6);
  static const onTertiaryContainer = onPrimary;

  // ON SURFACES

  static const onSurface = Color(0xFFF1F3F4);
  static const onSurface2 = Color(0xFF718B9C);

  // ERROR

  static const error = Color(0xFFC95A5A);
  static const onError = onSurface;
  static const errorContainer = Color(0xFFF9DEDC);
  static const onErrorContainer = Color(0xFF410E0B);

  // SHADOW
  static const shadow = Color(0x206B737A);

  static const scrim = Color(0x99000000);

  // SWITCH

  static const switchOn = primary;
  static const switchBg = Color(0xFF35434A);
  static const switchRipple = Color(0x1A9FC4C8);
}
