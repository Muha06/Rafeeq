import 'package:flutter/cupertino.dart';
import 'package:rafeeq/core/constants/colors/light_colors.dart';

class AppDarkColors {
  static const canvas = Color(0xFF12100e);

  static const surface = Color(0xFF1e1a16);
  static const surfaceDim = Color(0xFF171310); // lowest elevation
  static const surfaceHigh = Color(0xFF2a241f);

  static const outline = Color(0xFF3A332D);
  static const outlineVariant = Color(0xFF2A241F);

  static const tertiary = AppLightColors.brand;
  static const brand = Color(0xFFe4c169);

  static const onSurface = Color(0xFFEAF2F2);
  static const onSurface2 = Color(0xFF96A2A5);
  static const error = Color(0xFFFF5A6A);

  static const switchOn = Color(0xFFE4C169); // same as brand (unifies identity)
  static const switchOnBg = Color(0xFF2A241F); // matches surfaceHigh tone
  static const switchRipple = Color(0x33E4C169); // soft gold glow
}
