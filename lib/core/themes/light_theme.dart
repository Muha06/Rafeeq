import 'package:flutter/material.dart';
import 'package:rafeeq/core/constants/colors/light_colors.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/constants/typography/app_text_theme.dart';

ThemeData appLightThemeData() {
  final scheme = const ColorScheme.light(
    brightness: Brightness.light,
    primary: AppLightColors.brand,
    secondary: AppLightColors.secondary,
    tertiary: AppLightColors.tertiary,

    surface: AppLightColors.surface,
    outline: AppLightColors.outline,

    onPrimary: Colors.white,
    onSurface: AppLightColors.onSurface,

    error: AppLightColors.error,
    onError: Colors.white,
    surfaceContainerLowest: AppLightColors.canvas,
    surfaceContainerLow: AppLightColors.canvas,
    surfaceContainer: AppLightColors.surface,
    surfaceContainerHigh: AppLightColors.surfaceHigh,
    surfaceContainerHighest: AppLightColors.surfaceHighest,

    outlineVariant: AppLightColors.outlineVariant,
    onSurfaceVariant: AppLightColors.onSurface2,

    shadow: AppLightColors.shadow,
    scrim: AppLightColors.scrim,
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

    appBarTheme: AppBarThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
      toolbarHeight: 56,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      actionsIconTheme: IconThemeData(color: scheme.onSurface, weight: 1),
      iconTheme: IconThemeData(color: scheme.onSurface),
      titleTextStyle: base.headlineSmall?.copyWith(
        fontFamily: 'PlayfairDisplay',
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
        color: scheme.primary,
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(scheme.onSurface),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        visualDensity: VisualDensity.compact,
      ),
    ),

    tabBarTheme: const TabBarThemeData(
      labelStyle: TextStyle(
        fontFamily: AppStrings.primaryFont,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: AppLightColors.onSurface,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: AppStrings.primaryFont,
        fontSize: 15.5,
        fontWeight: FontWeight.w600,
        color: AppLightColors.onSurface2,
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
      backgroundColor: scheme.surface,
      selectedColor: scheme.primary,
      disabledColor: scheme.secondary,
      secondarySelectedColor: scheme.primary,
      showCheckmark: false,
      surfaceTintColor: Colors.transparent,
      labelStyle: TextStyle(
        color: scheme.onPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: const BorderSide(color: Colors.transparent),
      ),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      showDragHandle: true,
      modalBarrierColor: scheme.scrim,
      modalBackgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 2,
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerHighest),
        foregroundColor: WidgetStatePropertyAll(scheme.onSurface),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
          side: BorderSide(color: scheme.primary),
        ),
        side: BorderSide(color: scheme.primary, width: 1.25),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
      backgroundColor: scheme.surfaceContainerLowest,
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
      hintStyle: TextStyle(
        fontFamily: AppStrings.primaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: scheme.onSurfaceVariant,
      ),
      iconColor: scheme.onSurface,
      fillColor: scheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: Colors.transparent),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide(color: scheme.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide(color: scheme.error),
      ),
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: AppLightColors.onSurface2,
      enableFeedback: true,
      contentPadding: EdgeInsets.zero,
      titleTextStyle: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: AppLightColors.onSurface,
      ),
      subtitleTextStyle: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppLightColors.onSurface2,
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.disabled)) return scheme.onSurfaceVariant;
        if (s.contains(WidgetState.selected)) return AppLightColors.switchOn;
        return scheme.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.disabled)) return AppLightColors.switchBg;
        if (s.contains(WidgetState.selected)) return AppLightColors.switchBg;

        return AppLightColors.switchBg;
      }),
      overlayColor: const WidgetStatePropertyAll(AppLightColors.switchRipple),
    ),

    textTheme: AppTextTheme.build(scheme),
  );
}
