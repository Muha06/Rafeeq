import 'package:flutter/material.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'dark_colors.dart';

//DARK THEME
class AppTheme {
  //dark theme
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        },
      ),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppDarkColors.darkBackground,
      canvasColor: AppDarkColors.darkBackground,

      colorScheme: const ColorScheme.dark(
        surface: AppDarkColors.darkBackground, //hide the navigation color
        primary: AppDarkColors.amber,
      ),

      //APPBAR
      appBarTheme: AppBarTheme(
        backgroundColor: AppDarkColors.darkBackground,
        foregroundColor: AppDarkColors.textPrimary,
        toolbarHeight: 52,
        surfaceTintColor: Colors.transparent, // color when scrolling
        centerTitle: false,
        titleTextStyle: AppTextStyles.title,
        iconTheme: const IconThemeData(color: AppDarkColors.iconPrimary),
      ),

      //=====Text theme=======
      textTheme: TextTheme(
        //title
        titleLarge: AppTextStyles.title.copyWith(
          color: AppDarkColors.textPrimary, // for dark theme
          height: 1,
        ),
        //arabic
        bodyLarge: AppTextStyles.quranBody.copyWith(
          color: AppDarkColors.textPrimary, // dark
        ),
        //Normal body
        bodyMedium: AppTextStyles.body.copyWith(
          color: AppDarkColors.textBody, // white
        ),
        //small text
        bodySmall: AppTextStyles.secondary.copyWith(
          color: AppDarkColors.textSecondary, // dark
        ),
      ),
      //CARD
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withAlpha(60),
        color: AppDarkColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      dividerColor: AppDarkColors.textSecondary.withAlpha(50),

      sliderTheme: const SliderThemeData(
        activeTrackColor: AppDarkColors.amber,
        thumbColor: AppDarkColors.amber,
        inactiveTrackColor: AppDarkColors.textSecondary,
      ),

      // ===== BUTTON THEME =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDarkColors.amber,
          foregroundColor: AppDarkColors.darkBackground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppDarkColors.amber,
          side: const BorderSide(color: AppDarkColors.amber),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppDarkColors.amber,
          overlayColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          padding: EdgeInsets.zero, // remove all padding
          minimumSize: Size.zero, // optional: remove minimum size
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // shrink tap area
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        backgroundColor: AppDarkColors.darkSurface,
      ),
      iconTheme: const IconThemeData(color: AppDarkColors.textBody),
    );
  }

  //light theme
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        },
      ),
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppLightColors.lightBackground,
      colorScheme: const ColorScheme.light(
        surface: AppLightColors.lightSurface,
        primary: AppLightColors.amber,
      ),

      // ===== APPBAR =====
      appBarTheme: const AppBarTheme(
        backgroundColor: AppLightColors.lightBackground,
        surfaceTintColor: AppLightColors.lightBackground,
        foregroundColor: AppLightColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 48,
        iconTheme: IconThemeData(color: AppLightColors.iconPrimary),
      ),

      //=====text theme========
      textTheme: TextTheme(
        //title
        titleLarge: AppTextStyles.title.copyWith(
          color: AppLightColors.textPrimary,
        ),

        //Arabic
        bodyLarge: AppTextStyles.quranBody.copyWith(
          color: AppLightColors.textPrimary,
        ),

        //Normal body(Translation)
        bodyMedium: AppTextStyles.body.copyWith(
          color: AppLightColors.textPrimary,
        ),

        //small text
        bodySmall: AppTextStyles.secondary.copyWith(
          color: AppLightColors.textSecondary,
        ),
      ),

      // ===== CARD =====
      cardColor: AppLightColors.lightSurface,
      dividerColor: AppLightColors.divider,
      dividerTheme: const DividerThemeData(space: 0),
      iconTheme: const IconThemeData(color: AppLightColors.iconPrimary),

      // ===== SLIDER =====
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppLightColors.amber,
        thumbColor: AppLightColors.amber,
        inactiveTrackColor: AppLightColors.textSecondary,
      ),

      // ===== BUTTONS =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppLightColors.amber,
          foregroundColor: AppLightColors.lightBackground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          elevation: 0,
          shadowColor: Colors.transparent, // optional if you want no shadow
          splashFactory: InkRipple.splashFactory,
          overlayColor: AppLightColors.textBody,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppLightColors.amber,
          side: const BorderSide(color: AppLightColors.amber),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          backgroundColor: Colors.transparent, // optional, usually default
          splashFactory: InkRipple.splashFactory, //splash
          overlayColor: AppLightColors.amber,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppLightColors.amber,
          overlayColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          padding: EdgeInsets.zero, // remove all padding
          minimumSize: Size.zero, // optional: remove minimum size
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // shrink tap area
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        backgroundColor: AppLightColors.lightBackground,
      ),
    );
  }
}
