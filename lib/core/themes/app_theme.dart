import 'package:flutter/material.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'app_colors.dart';

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
      scaffoldBackgroundColor: AppColors.darkBackground,

      colorScheme: const ColorScheme.dark(
        surface: AppColors.darkBackground,
        primary: AppColors.amber,
      ),

      //APPBAR
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.textPrimary,
        toolbarHeight: 48,
        shadowColor: AppColors.textSecondary.withAlpha(150),
        scrolledUnderElevation: 1, //this creates the divider effect
        surfaceTintColor: Colors.transparent, // color when scrolling
        centerTitle: false,
        titleTextStyle: AppTextStyles.title.copyWith(fontFamily: 'Inter'),
        actionsIconTheme: const IconThemeData(color: Colors.white, size: 26),
      ),

      //=====Text theme=======
      textTheme: TextTheme(
        //title
        titleLarge: AppTextStyles.title.copyWith(
          color: AppColors.textPrimary, // for dark theme
        ),
        //arabic
        bodyLarge: AppTextStyles.quranBody.copyWith(
          color: AppColors.textPrimary, // dark
        ),
        //Normal body
        bodyMedium: AppTextStyles.body.copyWith(
          color: AppColors.textBody, // dark
        ),
        //small text
        bodySmall: AppTextStyles.secondary.copyWith(
          color: AppColors.textSecondary, // dark
        ),
      ),
      //CARD
      cardColor: AppColors.darkSurface,

      dividerColor: AppColors.textSecondary.withAlpha(50),

      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.amber,
        thumbColor: AppColors.amber,
        inactiveTrackColor: AppColors.textSecondary,
      ),

      // ===== BUTTON THEME =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amber,
          foregroundColor: AppColors.darkBackground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.amber,
          side: const BorderSide(color: AppColors.amber),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          overlayColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        backgroundColor: AppColors.darkSurface,
      ),
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
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        surface: AppColors.lightSurface,
        primary: AppColors.amber,
      ),

      // ===== APPBAR =====
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 48,
        scrolledUnderElevation: 1, //this creates the divider effect
        surfaceTintColor: Colors.transparent, // color when scrolling
      ),

      //=====text theme========
      textTheme: TextTheme(
        //title
        titleLarge: AppTextStyles.title.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        //Arabic
        bodyLarge: AppTextStyles.quranBody.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        //Normal body
        bodyMedium: AppTextStyles.body.copyWith(color: AppColors.lightTextBody),
        //small text
        bodySmall: AppTextStyles.secondary.copyWith(
          color: AppColors.lightTextSecondary,
        ),
      ),

      // ===== CARD =====
      cardColor: AppColors.lightSurface,
      dividerColor: AppColors.lightTextSecondary.withAlpha(50),

      // ===== SLIDER =====
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.amber,
        thumbColor: AppColors.amber,
        inactiveTrackColor: AppColors.lightTextSecondary,
      ),

      // ===== BUTTONS =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amber,
          foregroundColor: AppColors.lightBackground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          elevation: 0,
          shadowColor: Colors.transparent, // optional if you want no shadow
          splashFactory: InkRipple.splashFactory,
          overlayColor: AppColors.lightTextBody,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.amber,
          side: const BorderSide(color: AppColors.amber),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          backgroundColor: Colors.transparent, // optional, usually default
          splashFactory: InkRipple.splashFactory, //splash
          overlayColor: AppColors.amber,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(AppColors.amber),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        backgroundColor: AppColors.lightSurface,
      ),
    );
  }
}
