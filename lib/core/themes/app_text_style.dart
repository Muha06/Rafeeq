import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Titles (AppBar, headings)
  static final TextStyle title = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  // Qur'an Arabic text
  static final TextStyle quranBody = const TextStyle(
    fontFamily: 'Uthmani',
    fontSize: 32,
    height: 1.8,
    wordSpacing: 2,
    fontFamilyFallback: [
      'NotoNaskhArabic', // or Amiri
      'Amiri',
    ],
  );

  // Main body text(Translation)
  static final TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    height: 1.7,
    letterSpacing: 0.2,
  );

  // Secondary / caption text
  static final TextStyle secondary = GoogleFonts.inter(
    fontSize: 14,
    height: 1.2,
  );
}
