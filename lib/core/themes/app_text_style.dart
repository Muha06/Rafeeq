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
    fontSize: 22,
    height: 2,
    //fontweight: set in the widget
    wordSpacing: 2,
  );

  // Main body text(Translation)
  static final TextStyle body = GoogleFonts.inter(
    fontSize: 19,
    height: 1.7,
    // fontWeight: FontWeight.w400, set in the text widget
    letterSpacing: 2,
  );

  // Secondary / caption text
  static final TextStyle secondary = GoogleFonts.lato(fontSize: 12, height: 1);
}
