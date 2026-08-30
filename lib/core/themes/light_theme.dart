import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rafeeq/core/constants/colors/light_colors.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/constants/typography/app_text_theme.dart';

ThemeData appLightThemeData() {
  final scheme = const ColorScheme.light(
    brightness: Brightness.light,

    // PRIMARY || SECONDARY || TERTIARY
    primary: AppLightColors.primary,
    secondary: AppLightColors.secondary,
    tertiary: AppLightColors.tertiary,

    // ON PRIMARY || SECONDARY || TERTIARY
    onPrimary: AppLightColors.canvas,
    onSecondary: AppLightColors.canvas,
    onTertiary: AppLightColors.onTertiary,

    // CONTAINERS
    primaryContainer: AppLightColors.primaryContainer,
    secondaryContainer: AppLightColors.secondaryContainer,
    tertiaryContainer: AppLightColors.tertiaryContainer,

    // ON CONTAINERS
    onPrimaryContainer: AppLightColors.onPrimaryContainer,
    onSecondaryContainer: AppLightColors.onSecondaryContainer,
    onTertiaryContainer: AppLightColors.onTertiaryContainer,

    surface: AppLightColors.surface,
    onSurface: AppLightColors.onSurface,

    outline: AppLightColors.outline,

    error: AppLightColors.error,
    errorContainer: AppLightColors.errorContainer,
    onErrorContainer: AppLightColors.onErrorContainer,
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
    fontFamily: AppStrings.primaryFont,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: scheme,

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    visualDensity: VisualDensity.compact,

    scaffoldBackgroundColor: scheme.surfaceContainerLowest,
    canvasColor: scheme.surfaceContainerLowest,
    hintColor: scheme.onSurfaceVariant,
    disabledColor: scheme.onSurfaceVariant.withAlpha(140),
    fontFamily: AppStrings.primaryFont,

    dividerColor: scheme.outlineVariant,
    dividerTheme: DividerThemeData(color: scheme.outlineVariant),
    textTheme: AppTextTheme.build(scheme),

    appBarTheme: AppBarThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
      toolbarHeight: 56,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      actionsIconTheme: IconThemeData(color: scheme.onSurface, weight: 1),
      iconTheme: IconThemeData(color: scheme.onSurface),
      titleTextStyle: base.headlineSmall?.copyWith(
        fontFamily: AppStrings.displayFont,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.4,
        color: scheme.onSurface,
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

    tabBarTheme: TabBarThemeData(
      labelStyle: TextStyle(
        fontFamily: AppStrings.primaryFont,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.3,
        color: scheme.onSurfaceVariant,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: AppStrings.primaryFont,
        fontSize: 15.5,
        fontWeight: FontWeight.w500,
        color: scheme.onSurfaceVariant,
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
        fontSize: 15,
      ),
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: const BorderSide(color: Colors.transparent),
      ),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppLightColors.canvas,
      showDragHandle: true,
      modalBarrierColor: scheme.scrim,
      shadowColor: scheme.shadow,
      modalBackgroundColor: AppLightColors.canvas,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
      elevation: 2,
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      strokeWidth: 3.5,
      linearTrackColor: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(999),
      color: scheme.primary,
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: scheme.primary,
      thumbColor: scheme.primary,
      inactiveTrackColor: scheme.surface,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        iconColor: scheme.onPrimary,
        disabledBackgroundColor: scheme.surfaceContainerHighest,
        disabledForegroundColor: scheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          height: 1,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerHighest),
        foregroundColor: WidgetStatePropertyAll(scheme.onSurface),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          height: 1,
          fontSize: 16,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        iconColor: scheme.primary,
        foregroundColor: scheme.primary,
        overlayColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          height: 1,
          fontSize: 16,
        ),
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        fontSize: 16,
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

    listTileTheme: ListTileThemeData(
      iconColor: scheme.onSurfaceVariant,
      enableFeedback: true,
      contentPadding: EdgeInsets.zero,
      titleTextStyle: TextStyle(
        fontFamily: AppStrings.primaryFont,
        fontSize: 17.5,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.3,
        color: scheme.onSurface,
      ),
      subtitleTextStyle: TextStyle(
        fontFamily: AppStrings.primaryFont,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: scheme.onSurfaceVariant,
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

    timePickerTheme: TimePickerThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      hourMinuteColor: scheme.surface,
      hourMinuteTextColor: scheme.onSurface,
      dialHandColor: scheme.primary,
      dialBackgroundColor: scheme.surface,
      dialTextColor: scheme.onSurface,
      entryModeIconColor: scheme.onSurface,
      timeSelectorSeparatorColor: WidgetStatePropertyAll(scheme.primary),
      confirmButtonStyle: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(scheme.primary),
        foregroundColor: WidgetStatePropertyAll(scheme.onPrimary),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
      ),
    ),
  );
}
