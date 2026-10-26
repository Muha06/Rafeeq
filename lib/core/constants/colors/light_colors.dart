import 'package:flutter/material.dart';

class AppLightColors {
  //  BACKGROUND
  static const canvas = Color(0xFFFAF8F3); // warm off-white
  static const surfaceLow = Color(0xFFF5F2EB);

  // SURFACES (cards are white, so they lift off the canvas)
  static const surface = Color(0xFFFFFFFF);
  static const surfaceHigh = Color(0xFFEFEBE2);
  static const surfaceHighest = Color(0xFFD9D3C5);

  //  BORDERS / DIVIDERS
  static const outline = Color(0xFFE7E2D6);
  static const outlineVariant = Color(0xFFD3CCBC);

  //  PRIMARY || SECONDARY || TERTIARY
  static const primary = Color(0xFF4A3510); // deep brown, ~11:1 with white
  static const secondary = Color(0xFF7A6A55); // warm taupe
  static const tertiary = Color(0xFFD9A441); // gold accent, used sparingly

  // ON  P | S | T
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSecondary = Color(0xFFFFFFFF);
  static const onTertiary = Color(0xFF2A1D08);

  // CONTAINERS
  static const primaryContainer = Color(0xFFEBE2D3); // light sand-brown
  static const secondaryContainer = Color(0xFFEDE6DA);
  static const tertiaryContainer = Color(0xFFF6E8C8);

  // ON CONTAINERS
  static const onPrimaryContainer = Color(0xFF2E2008);
  static const onSecondaryContainer = onSurface;
  static const onTertiaryContainer = Color(0xFF4A3510);

  // ON SURFACES
  static const onSurface = Color(0xFF2B2118); // warm dark ink
  static const onSurface2 = Color(0xFF6E6050); // secondary text, ~5.5:1

  //  ERROR
  static const error = Color(0xFFC95A5A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFF9DEDC);
  static const onErrorContainer = Color(0xFF410E0B);

  // SHADOW
  static const shadow = Color(0x142B2118); // warm-tinted
  static const scrim = Color(0x99000000);

  //  SWITCH
  static const switchOn = primary;
  static const switchBg = Color(0xFFE3DACB);
  static const switchRipple = Color(0x1A4A3510);
}
