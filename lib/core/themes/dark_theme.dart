import 'package:flutter/material.dart';
import 'package:rafeeq/core/constants/colors/dark_colors.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/constants/typography/app_text_theme.dart';

ThemeData appDarkThemeData() {
  final scheme = const ColorScheme.dark(
    brightness: Brightness.dark,

    // PRIMARY || SECONDARY || TERTIARY
    primary: AppDarkColors.primary,
    secondary: AppDarkColors.secondary,
    tertiary: AppDarkColors.tertiary,

    // ON PRIMARY || SECONDARY || TERTIARY
    onPrimary: AppDarkColors.onPrimary,
    onSecondary: AppDarkColors.onSecondary,
    onTertiary: AppDarkColors.onTertiary,

    // CONTAINERS
    primaryContainer: AppDarkColors.primaryContainer,
    secondaryContainer: AppDarkColors.secondaryContainer,
    tertiaryContainer: AppDarkColors.tertiaryContainer,

    // ON CONTAINERS
    onPrimaryContainer: AppDarkColors.onPrimaryContainer,
    onSecondaryContainer: AppDarkColors.onSecondaryContainer,
    onTertiaryContainer: AppDarkColors.onTertiaryContainer,

    surface: AppDarkColors.surface,
    onSurface: AppDarkColors.onSurface,

    outline: AppDarkColors.outline,

    error: AppDarkColors.error,
    errorContainer: AppDarkColors.errorContainer,
    onErrorContainer: AppDarkColors.onErrorContainer,
    onError: AppDarkColors.onError,

    surfaceContainerLowest: AppDarkColors.canvas,
    surfaceContainerLow: AppDarkColors.canvas,
    surfaceContainer: AppDarkColors.surface,
    surfaceContainerHigh: AppDarkColors.surfaceHigh,
    surfaceContainerHighest: AppDarkColors.surfaceHighest,

    outlineVariant: AppDarkColors.outlineVariant,
    onSurfaceVariant: AppDarkColors.onSurface2,

    shadow: AppDarkColors.shadow,
    scrim: AppDarkColors.scrim,
  );

  final base = Typography.material2021().white.apply(
    fontFamily: AppStrings.primaryFont,
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

    shadowColor: scheme.shadow,
    scaffoldBackgroundColor: scheme.surfaceContainerLowest,
    canvasColor: scheme.surfaceContainerLowest,
    hintColor: scheme.onSurfaceVariant,
    disabledColor: scheme.onSurfaceVariant.withAlpha(140),
    fontFamily: AppStrings.primaryFont,

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
        color: scheme.primary,
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
      backgroundColor: scheme.surfaceContainerLowest,
      showDragHandle: true,
      shadowColor: scheme.shadow,
      modalBarrierColor: scheme.scrim,
      modalBackgroundColor: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
      inactiveTrackColor: scheme.surfaceContainerHigh,
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

    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
        if (s.contains(WidgetState.selected)) return AppDarkColors.switchOn;
        return scheme.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.disabled)) return scheme.surfaceContainer;
        if (s.contains(WidgetState.selected)) return scheme.primaryContainer;
        return scheme.surfaceContainerHigh;
      }),
      overlayColor: const WidgetStatePropertyAll(AppDarkColors.switchRipple),
    ),

    textTheme: AppTextTheme.build(scheme),

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
