// import 'package:flutter/material.dart';
// import 'package:rafeeq/core/themes/app_text_style.dart';

// ThemeData appLightThemeData() {
//   final scheme =
//       const ColorScheme.light(
//         brightness: Brightness.light,
//         primary: AppLightColors.brand,
//         onPrimary: AppLightColors.canvas,
//         surface: AppLightColors.surface,
//         onSurface: AppLightColors.onSurface,
//         error: AppLightColors.error,
//         onError: Colors.white,
//         outline: AppLightColors.outline,
//       ).copyWith(
//         surfaceContainerLowest: AppLightColors.canvas,
//         surfaceContainerLow: AppLightColors.surfaceDim,
//         surfaceContainer: AppLightColors.surface,
//         surfaceContainerHigh: AppLightColors.surfaceHigh,
//         surfaceContainerHighest: AppLightColors.surfaceHigh,
//         outlineVariant: AppLightColors.outlineVariant,
//         onSurfaceVariant: AppLightColors.onSurface2,
//       );

//   return ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.light,
//     colorScheme: scheme,
//     scaffoldBackgroundColor: scheme.surfaceContainerLowest,
//     canvasColor: scheme.surfaceContainerLowest,
//     hintColor: scheme.onSurfaceVariant,
//     disabledColor: scheme.onSurfaceVariant.withAlpha(140),
//     dividerColor: scheme.outlineVariant,
//     dividerTheme: DividerThemeData(color: scheme.outlineVariant),
//     iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
//     iconButtonTheme: IconButtonThemeData(
//       style: ButtonStyle(
//         iconColor: WidgetStatePropertyAll(scheme.onSurface),
//         overlayColor: WidgetStatePropertyAll(scheme.onSurface.withAlpha(18)),
//       ),
//     ),

//     appBarTheme: AppBarTheme(
//       backgroundColor: scheme.surfaceContainerLowest,
//       toolbarHeight: 52,
//       foregroundColor: scheme.onSurface,
//       elevation: 0,
//       surfaceTintColor: Colors.transparent,
//     ),

//     cardTheme: CardThemeData(
//       color: scheme.surfaceContainer,
//       elevation: 2,
//       shadowColor: Colors.black.withAlpha(60),
//       surfaceTintColor: Colors.transparent,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//     ),

//     chipTheme: ChipThemeData(
//       backgroundColor: scheme.surface,
//       labelStyle: TextStyle(color: scheme.onSurfaceVariant),
//       iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(999),
//         side: const BorderSide(color: Colors.transparent),
//       ),
//     ),

//     bottomSheetTheme: BottomSheetThemeData(
//       backgroundColor: scheme.surface,
//       showDragHandle: true,
//       modalBackgroundColor: scheme.surface,
//       surfaceTintColor: Colors.transparent,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//     ),

//     progressIndicatorTheme: ProgressIndicatorThemeData(
//       strokeWidth: 3.5,
//       color: scheme.primary,
//     ),

//     sliderTheme: SliderThemeData(
//       activeTrackColor: scheme.primary,
//       thumbColor: scheme.primary,
//       inactiveTrackColor: Colors.grey.withAlpha(100),
//     ),

//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: scheme.primary,
//         foregroundColor: scheme.onPrimary,
//         iconColor: scheme.onPrimary,
//         disabledBackgroundColor: scheme.surfaceContainerHigh,
//         disabledForegroundColor: scheme.onSurfaceVariant,
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
//       ),
//     ),

//     filledButtonTheme: FilledButtonThemeData(
//       style: ButtonStyle(
//         backgroundColor: WidgetStatePropertyAll(scheme.primary),
//         foregroundColor: WidgetStatePropertyAll(scheme.onPrimary),
//         padding: const WidgetStatePropertyAll(
//           EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         ),
//         textStyle: const WidgetStatePropertyAll(
//           TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//         ),
//         shape: WidgetStatePropertyAll(
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
//         ),
//       ),
//     ),

//     outlinedButtonTheme: OutlinedButtonThemeData(
//       style: OutlinedButton.styleFrom(
//         backgroundColor: Colors.transparent,
//         foregroundColor: scheme.onSurface,
//         iconColor: scheme.onSurface,
//         disabledForegroundColor: scheme.onSurfaceVariant,
//         side: BorderSide(color: scheme.outline),
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
//         textStyle: const TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
//       ),
//     ),

//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(
//         iconColor: scheme.onSurface,
//         foregroundColor: scheme.onSurface,
//         overlayColor: Colors.transparent,
//         splashFactory: NoSplash.splashFactory,
//         textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//         padding: EdgeInsets.zero,
//         minimumSize: Size.zero,
//         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//       ),
//     ),

//     dialogTheme: DialogThemeData(
//       backgroundColor: scheme.surface,
//       surfaceTintColor: Colors.transparent,
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//         side: BorderSide(color: scheme.outlineVariant),
//       ),
//     ),

//     textSelectionTheme: TextSelectionThemeData(
//       cursorColor: scheme.onSurfaceVariant,
//       selectionColor: scheme.primary.withAlpha(51), // ~20%
//       selectionHandleColor: scheme.primary,
//     ),

//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: scheme.surfaceContainerHighest,
//       hintStyle: TextStyle(color: scheme.onSurfaceVariant),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: scheme.outlineVariant),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: scheme.outlineVariant),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: scheme.primary),
//       ),
//     ),

//     listTileTheme: ListTileThemeData(
//       iconColor: scheme.onSurfaceVariant,
//       textColor: scheme.onSurface,
//       subtitleTextStyle: TextStyle(color: scheme.onSurfaceVariant),
//     ),

//     switchTheme: SwitchThemeData(
//       thumbColor: WidgetStateProperty.resolveWith((s) {
//         if (s.contains(WidgetState.disabled)) return scheme.onSurfaceVariant;
//         if (s.contains(WidgetState.selected)) return AppLightColors.switchOn;
//         return scheme.onSurfaceVariant;
//       }),
//       trackColor: WidgetStateProperty.resolveWith((s) {
//         if (s.contains(WidgetState.disabled)) return scheme.surfaceContainer;
//         if (s.contains(WidgetState.selected)) return AppLightColors.switchOnBg;
//         return scheme.surfaceContainerHigh;
//       }),
//       overlayColor: const WidgetStatePropertyAll(AppLightColors.switchRipple),
//     ),

//     textTheme: TextTheme(
//       titleLarge: AppTextStyles.title.copyWith(color: scheme.onSurface),
//       titleMedium: AppTextStyles.section.copyWith(color: scheme.onSurface),
//       titleSmall: AppTextStyles.section.copyWith(
//         color: scheme.onSurfaceVariant,
//       ),
//       bodyLarge: AppTextStyles.quranBody.copyWith(color: scheme.onSurface),
//       bodyMedium: AppTextStyles.paragraph.copyWith(color: scheme.onSurface),
//       bodySmall: AppTextStyles.secondary.copyWith(color: scheme.onSurface),
//       labelLarge: AppTextStyles.body.copyWith(color: scheme.onSurface),
//       labelMedium: AppTextStyles.label.copyWith(
//         color: scheme.onSurfaceVariant.withAlpha(217),
//       ),
//       labelSmall: AppTextStyles.label.copyWith(
//         color: scheme.onSurfaceVariant.withAlpha(210),
//       ),
//     ),
//   );
// }

// class AppLightColors {
//   static const canvas = Color(0xFFF9F5F0);

//   static const surface = Color(0xFFFCF4E9);
//   static const surfaceDim = Color(0xFFFBE8DD);
//   static const surfaceHigh = Color(0xFFFDEDDD);

//   static const outline = brand;
//   static const outlineVariant = Color(0xFFD8CABF);

//   static const brand = Color(0xFF795449); // new earthy warm brand

//   static const onSurface = Color(0xFF1D1D1B);
//   static const onSurface2 = Color(0xFF6E6A62);

//   static const error = Color(0xFFFF5A6A);

//   static const switchOn = Color(0xFF795449); // match brand
//   static const switchOnBg = Color(0xFFFDECDD); // gentle warm highlight
//   static const switchRipple = Color(0x1A795449);
// }
