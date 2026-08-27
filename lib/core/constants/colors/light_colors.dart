import 'package:flutter/painting.dart';

class AppLightColors {
  //  BACKGROUND
  static const canvas = Color(0xFFFFFFFF);

  //  SURFACES
  static const surface = Color(0xFFF3F7F8);
  static const surfaceHigh = Color(0xFFD5E0E4);
  static const surfaceHighest = Color(0xFFBACBD1);

  //  BORDERS / DIVIDERS
  static const outline = Color(0xFFE1E6E8);
  static const outlineVariant = Color(0xFFCDD4D7);

  //  PRIMARY || SECONDARY || TERTIARY
  static const primary = Color(0xFF1D98A8);
  static const secondary = Color(0xFF8D9AA6);
  static const tertiary = Color(0xFFA4DF3F); // Special accent (Used sparingly)

  // ON  P | S | T
  static const onPrimary = canvas;
  static const onSecondary = onSurface;
  static const onTertiary = onSurface;

  // CONTAINERS
  static const primaryContainer = Color(0xFFD3FAF9); // lighter primary
  static const secondaryContainer = Color(0xFFDCE2E6); // lighter secondary
  static const tertiaryContainer = Color(0xFFDBEEBA); // lighter tertiary

  // ON CONTAINERS
  static const onPrimaryContainer = Color(0xFF3D2B12);
  static const onSecondaryContainer = onSurface2;
  static const onTertiaryContainer = onSurface;

  // ON SURFACES
  static const onSurface = Color(0xFF303236);
  static const onSurface2 = Color(0xFF568A91);

  //  ERROR
  static const error = Color(0xFFC95A5A);
  static const onError = canvas;
  static const errorContainer = Color(0xFFF9DEDC);
  static const onErrorContainer = Color(0xFF410E0B);

  // SHADOW
  static const shadow = Color(0x0A000000);
  static const scrim = Color(0x99000000);

  //  SWITCH
  static const switchOn = primary;
  static const switchBg = Color(0xFFDCEEEE);
  static const switchRipple = Color(0x1A2F6F73);
}
