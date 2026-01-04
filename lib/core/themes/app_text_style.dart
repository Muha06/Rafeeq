import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Titles (AppBar, headings)
  static final TextStyle title = GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  // Qur'an Arabic text
  static final TextStyle quranBody = GoogleFonts.amiri(
    // fontFamily: 'Scheherazade', // or AmiriQuran, Cairo
    fontSize: 20,
    height: 2.0,
    fontWeight: FontWeight.w400,
  );

  // Main body text
  static final TextStyle body = GoogleFonts.lato(fontSize: 16, height: 1.6);

  // Secondary / caption text
  static final TextStyle secondary = GoogleFonts.lato(fontSize: 14);
}
