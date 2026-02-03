import 'package:flutter/material.dart';

class AppDarkColors {
  // ✅ Your base
  static const Color darkBackground = Color(0xFF071013); // #071013
  static const Color darkSurface = Color(0xCC0F1F25);
  // static const Color onDarkSurface = selectedCardBorder;
  static const Color onDarkSurface = Color(0xCC14262D); // #CC14262D

  static const Color darkSurfaceSolid = Color(0xFF0F1F25);

  // ✨ Accent (keep your amber, but add a dim + soft)
  static const Color amber = Color(0xFFFFC36A);
  static const Color amberSoft = Color(0x33FFC36A); // 20% highlight bg

  // ✅ Teal supporting accent (small use: links, active states if you want)
  static const Color teal = Color(0xFF22C6A6);
  static const Color tealSoft = Color(0x3322C6A6); // 20%

  // 📝 Text (slightly warmer + softer so it doesn't look sterile)
  static const Color textPrimary = Color(0xFFEAF2F2);
  static const Color textBody = Color(0xFFCAD6D8);
  static const Color textSecondary = Color(0xFF93A9AB);
  static const Color textHint = Color(0xFF6F8587);

  // ⚡ Icons
  static const Color iconPrimary = textPrimary;
  static const Color iconSecondary = textSecondary;
  static const Color iconDisabled = Color(0xFF5E7376);

  // 🎛 Buttons
  static const Color buttonPrimary = amber;
  static const Color buttonPrimaryPressed = amberSoft;
  static const Color buttonSecondary = Color(0xFF0E2A2D); // teal-dark
  static const Color buttonDisabled = Color(0xFF1A2A2E);

  // 📌 Selected states / highlights
  static const Color selectedPillBg = amberSoft; // behind selected nav
  static const Color selectedCardBorder = Color(0xFF1E3B40);

  // 🌑 Borders / Dividers (teal-ish, subtle)
  static const Color divider = Color(0xFF0E2A2D);
  static const Color border = Color(0xFF123238);

  // Bottom bar / sheets (match your surface stack)
  static const Color bottomBar = darkSurface;
  static const Color bottomSheet = Color(0xFF081214); // slightly closer to bg

  // ⚠️ Feedback (match the palette; less “random red/green”)
  static const Color errorColor = Color(0xFFFF5A6A);
  static const Color successColor = Color(0xFF2FD07F);
  static const Color warningColor = amber;

  // 🔘 Switch (teal, calm, dark)
  static const Color switchThumbOn = Color(0xFF1EAE93); // dim teal (ON thumb)
  static const Color switchThumbOff = Color(0xFF93A9AB); // muted (OFF thumb)
  static const Color switchThumbDisabled = Color(0xFF5E7376);

  static const Color switchTrackOn = Color(0xFF0B2A2A); // deep teal track (ON)
  static const Color switchTrackOff = Color(
    0xFF14262D,
  ); // same as onDarkSurface vibe
  static const Color switchTrackDisabled = Color(0xFF1A2A2E);

  static const Color switchOutlineOn = Color(0xFF1A6F63); // subtle teal outline
  static const Color switchOutlineOff = Color(0xFF123238); // your border
  static const Color switchOutlineDisabled = Color(0xFF0E2A2D);

  static const Color switchOverlay = Color(
    0x1A22C6A6,
  ); // 10% teal ripple (pressed)
}
