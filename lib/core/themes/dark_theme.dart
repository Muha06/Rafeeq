import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appDarkThemeData() {
  final scheme =
      const ColorScheme.dark(
        primary: AppDarkColors.brand, // accent color
        onPrimary: AppDarkColors.canvas, // text/icons on accent
        surface: AppDarkColors.surface, // base surface for cards
        onSurface: AppDarkColors.onSurface, // main text/icons on surfaces
        error: AppDarkColors.error,
        onError: Colors.white,
        outline: AppDarkColors.outline, // outlines
        tertiary: AppDarkColors
            .tertiary, // used for chips and highlights above primary
      ).copyWith(
        // Material 3 container ladder
        surfaceContainerLowest: AppDarkColors.canvas, // page bg
        surfaceContainerLow: AppDarkColors.surfaceDim, // sheets / sections
        surfaceContainer: AppDarkColors.surface, // cards
        surfaceContainerHigh: AppDarkColors.surfaceHigh, // elevated containers
        surfaceContainerHighest:
            AppDarkColors.surfaceHigh, // dialogs/menus (same for now)

        outlineVariant: AppDarkColors.outlineVariant, // subtle borders/dividers
        onSurfaceVariant: AppDarkColors.onSurface2, // quieter text/icons
      );

  final base = GoogleFonts.plusJakartaSansTextTheme(
    Typography.material2021().white,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
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

    iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
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
      elevation: 2,
      shadowColor: Colors.black.withAlpha(60),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceContainerHigh,
      labelStyle: TextStyle(color: scheme.onSurfaceVariant),
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
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
        disabledBackgroundColor: scheme.surfaceContainerHigh,
        disabledForegroundColor: scheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerHigh),
        foregroundColor: WidgetStatePropertyAll(scheme.primary.withAlpha(210)),
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
        disabledForegroundColor: scheme.onSurfaceVariant,
        side: BorderSide(color: scheme.onSurface.withAlpha(100)),
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
        visualDensity: VisualDensity.compact,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
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
        if (s.contains(WidgetState.selected)) return AppDarkColors.switchOn;
        return scheme.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.disabled)) return scheme.surfaceContainer;
        if (s.contains(WidgetState.selected)) return AppDarkColors.switchOnBg;
        return scheme.surfaceContainerHigh;
      }),
      overlayColor: const WidgetStatePropertyAll(AppDarkColors.switchRipple),
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
        fontWeight: FontWeight.w700,
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

class AppDarkColors {
  static const canvas = Color(0xFF12100e);

  static const surface = Color(0xFF1e1a16);
  static const surfaceDim = Color(0xFF171310); // lowest elevation
  static const surfaceHigh = Color(0xFF2a241f);

  static const outline = Color(0xFF3A332D);
  static const outlineVariant = Color(0xFF2A241F);

  static const tertiary = Color(0xFF7FAFA2);
  static const brand = Color(0xFFe4c169);

  static const onSurface = Color(0xFFEAF2F2);
  static const onSurface2 = Color(0xFFCAD6D8);

  static const error = Color(0xFFFF5A6A);

  static const switchOn = Color(0xFFE4C169); // same as brand (unifies identity)
  static const switchOnBg = Color(0xFF2A241F); // matches surfaceHigh tone
  static const switchRipple = Color(0x33E4C169); // soft gold glow
}
