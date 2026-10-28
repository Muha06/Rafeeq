import 'package:flutter/painting.dart';

class AppDarkColors {
  // BACKGROUND
  static const canvas = Color(0xFF08110E); // deep emerald-black
  static const surfaceLow = Color(0xFF0D1814); // Bottomsheets, dialogs

  // SURFACES
  static const surface = Color(0xFF121F1A);
  static const surfaceHigh = Color(0xFF1A2B24);
  static const surfaceHighest = Color(0xFF263A31);

  // BORDERS / DIVIDERS (green-tinted, subtle)
  static const outline = Color(0xFF27382F);
  static const outlineVariant = Color(0xFF36493F);

  // PRIMARY || SECONDARY || TERTIARY
  static const primary = Color(0xFF35A77E); // deeper emerald
  static const secondary = Color(0xFFA9B8AF); // soft sage
  static const tertiary = Color(0xFFD9B35F); // muted gold

  // ON P | S | T
  static const onPrimary = Color(0xFF03271B);
  static const onSecondary = Color(0xFF1B251F);
  static const onTertiary = Color(0xFF2B1F06);

  // CONTAINERS
  static const primaryContainer = Color(0xFF174B38);
  static const secondaryContainer = Color(0xFF2E3D35);
  static const tertiaryContainer = Color(0xFF3A3719); // olive-gold

  // ON CONTAINERS
  static const onPrimaryContainer = Color(0xFFCFF7E5);
  static const onSecondaryContainer = Color(0xFFDDE6E0);
  static const onTertiaryContainer = Color(0xFFF3EBC6);

  // ON SURFACES
  static const onSurface = Color(0xFFEFF3EE); // slightly warm white
  static const onSurface2 = Color(0xFF93A89C); // secondary text

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
  static const switchBg = Color(0xFF33453C);
  static const switchRipple = Color(0x1A35A77E); // matches new primary
}
