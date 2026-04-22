import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appLightThemeData() {
  final scheme =
      const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppLightColors.brand,
        onPrimary: Colors.white,

        //  Accent is reserved for subtle highlights, not interactive elements
        tertiary: AppLightColors.accent,

        surface: AppLightColors.surface,
        onSurface: AppLightColors.onSurface,

        error: AppLightColors.error,
        onError: Colors.white,

        outline: AppLightColors.outline,
      ).copyWith(
        surfaceContainerLowest: AppLightColors.canvas,
        surfaceContainerLow: AppLightColors.surfaceDim,
        surfaceContainer: AppLightColors.surface,
        surfaceContainerHigh: AppLightColors.surfaceHigh,
        surfaceContainerHighest: AppLightColors.surfaceHighest,

        outlineVariant: AppLightColors.outlineVariant,
        onSurfaceVariant: AppLightColors.onSurface2,
      );

  final base = GoogleFonts.plusJakartaSansTextTheme(
    Typography.material2021().white,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: scheme,

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      },
    ),

    scaffoldBackgroundColor: scheme.surfaceContainerLowest,
    canvasColor: scheme.surfaceContainerLowest,
    hintColor: scheme.onSurfaceVariant,
    disabledColor: scheme.onSurfaceVariant.withAlpha(140),

    dividerColor: scheme.outlineVariant,
    dividerTheme: DividerThemeData(color: scheme.outlineVariant),

    iconTheme: IconThemeData(color: scheme.onSurface),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(scheme.onSurface),
        overlayColor: WidgetStatePropertyAll(
          scheme.onSurface.withAlpha(18), // subtle ripple
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surfaceContainerLowest,
      toolbarHeight: 52,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    cardTheme: CardThemeData(
      color: scheme.surfaceContainer,
      shadowColor: Colors.black.withAlpha(80),
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: scheme.primary.withAlpha(48),
      labelStyle: TextStyle(color: scheme.onSurfaceVariant),
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: const BorderSide(color: Colors.transparent),
      ),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surface,
      showDragHandle: true,
      modalBackgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      strokeWidth: 3.5,
      linearTrackColor: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(999),
      color: scheme.primary,
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: scheme.primary,
      thumbColor: scheme.primary,
      inactiveTrackColor: Colors.grey.withAlpha(100),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        iconColor: scheme.onPrimary,
        disabledBackgroundColor: scheme.surfaceContainerHighest,
        disabledForegroundColor: scheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(scheme.primary),
        foregroundColor: WidgetStatePropertyAll(scheme.onPrimary),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.primary,
        iconColor: scheme.primary,
        iconSize: 16,
        disabledForegroundColor: scheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(color: scheme.onSurface),
        ),
        side: BorderSide(color: scheme.onSurfaceVariant),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        iconColor: scheme.onSurface,
        foregroundColor: scheme.primary,
        overlayColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: scheme.onSurfaceVariant,
      selectionColor: scheme.primary.withAlpha(51), // ~20%
      selectionHandleColor: scheme.primary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      iconColor: scheme.onSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.primary),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant.withAlpha(100)),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.error),
      ),
    ),

    listTileTheme: ListTileThemeData(
      iconColor: scheme.onSurfaceVariant,
      textColor: scheme.onSurface,
      subtitleTextStyle: TextStyle(color: scheme.onSurfaceVariant),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.disabled)) return scheme.onSurfaceVariant;
        if (s.contains(WidgetState.selected)) return AppLightColors.switchOn;
        return scheme.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.disabled)) return scheme.surfaceContainer;
        if (s.contains(WidgetState.selected)) return AppLightColors.switchOnBg;
        return scheme.surfaceContainerHigh;
      }),
      overlayColor: const WidgetStatePropertyAll(AppLightColors.switchRipple),
    ),

    textTheme: base.copyWith(
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.2,
        color: scheme.onSurface,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
        color: scheme.onSurface,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: scheme.onSurfaceVariant,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 15,
        height: 1.6,
        color: scheme.onSurface,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.65,
        color: scheme.onSurface,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12.5,
        height: 1.5,
        color: scheme.onSurfaceVariant,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: scheme.onSurface,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: scheme.onSurfaceVariant,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: scheme.onSurfaceVariant.withAlpha(210),
      ),
    ),
  );
}

class AppLightColors {
  // 🌤️ BACKGROUND (soft warm, not pure white)
  static const canvas = Color(0xFFFAFAF6);

  // 🧱 SURFACES (Material 3 ladder tuned warm)
  static const surface = Color(0xFFFFFFFF);
  // main cards (clean white pops on warm bg)

  static const surfaceDim = Color(0xFFF1F1ED);
  // sections / grouped areas

  static const surfaceHigh = Color(0xFFF7F7F3);
  // elevated containers (subtle lift)

  static const surfaceHighest = Color(0xFFEEEEEA);
  // dialogs / menus (slightly separated)

  // ➖ BORDERS / DIVIDERS (soft, not harsh)
  static const outline = Color(0xFFE3E3DF);
  static const outlineVariant = Color(0xFFEDEDE8);

  // 🟢 PRIMARY (muted teal, calm & premium)
  static const brand = Color(0xFF27687e);

  // 🟡 ACCENT (gold — highlights only, NOT actions)
  static const accent = Color(0xFFC9A24A);

  // ✍️ TEXT (softer contrast for premium feel)
  static const onSurface = Color(0xFF1F2A2C);
  static const onSurface2 = Color(0xFF6B7C7E);

  // ❌ ERROR (slightly softened red)
  static const error = Color(0xFFD64545);

  // 🔘 SWITCH (aligned with brand)
  static const switchOn = brand;
  static const switchOnBg = Color(0xFFDCEEEE);
  static const switchRipple = Color(0x1A2F6F73);
}
