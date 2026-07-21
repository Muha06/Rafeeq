import 'package:flutter/material.dart';

ThemeData appLightThemeData() {
  final scheme =
      const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppLightColors.brand,
        onPrimary: Colors.white,

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

  final base = Typography.material2021().black.apply(
    fontFamily: 'PlusJakartaSans',
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
    fontFamily: 'PlusJakartaSans',

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
      titleTextStyle: base.headlineSmall?.copyWith(
        fontFamily: 'PlayfairDisplay',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: scheme.onSurface,
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerHighest),
        foregroundColor: WidgetStatePropertyAll(scheme.onSurface),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
        side: BorderSide(color: scheme.onSurface),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        iconColor: scheme.primary,
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
      titleTextStyle: base.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.2,
        color: scheme.onSurface,
      ),
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
      headlineMedium: base.headlineSmall?.copyWith(
        fontFamily: 'PlayFairDisplay',
        fontSize: 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: scheme.onSurface,
      ),

      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: scheme.onSurface,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: scheme.onSurface,
      ),

      titleMedium: base.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: scheme.onSurface,
      ),

      titleSmall: base.titleSmall?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: scheme.onSurfaceVariant,
      ),

      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 17,
        height: 1.65,
        color: scheme.onSurface,
      ),

      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 15.5,
        height: 1.65,
        color: scheme.onSurface,
      ),

      bodySmall: base.bodySmall?.copyWith(
        fontSize: 14,
        height: 1.55,
        color: scheme.onSurfaceVariant,
      ),

      labelLarge: base.labelLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: scheme.onSurface,
      ),

      labelMedium: base.labelMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: scheme.onSurfaceVariant,
      ),

      labelSmall: base.labelSmall?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: scheme.onSurfaceVariant.withAlpha(210),
      ),
    ),
  );
}

class AppLightColors {
  // 🌤️ BACKGROUND (iOS system background)
  static const canvas = Color(0xFFF2F2F7);

  // 🧱 SURFACES
  static const surface = Color(0xFFFFFFFF); // Primary cards
  static const surfaceDim = Color(0xFFF7F7FA); // Grouped sections
  static const surfaceHigh = Color(0xFFFCFCFD); // Elevated cards
  static const surfaceHighest = Color(0xFFE3E5EA);

  // ➖ BORDERS / DIVIDERS (iOS style)
  static const outline = Color(0xFFE5E5EA);
  static const outlineVariant = Color(0xFFD0D0D8);

  // 🟢 PRIMARY
  static const brand = Color(0xFF27687E);

  // 🟡 ACCENT
  static const accent = Color(0xFFC9A24A);

  // ✍️ TEXT
  static const onSurface = Color(0xFF000000);
  static const onSurface2 = Color(0xFF8A9598);

  // ❌ ERROR
  static const error = Color(0xFFD64545);

  // 🔘 SWITCH
  static const switchOn = brand;
  static const switchOnBg = Color(0xFFDCEEEE);
  static const switchRipple = Color(0x1A2F6F73);
}
