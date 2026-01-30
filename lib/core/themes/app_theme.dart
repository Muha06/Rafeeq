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

      dividerColor: AppDarkColors.divider,
      cardColor: AppDarkColors.darkSurface,
      iconTheme: const IconThemeData(color: AppDarkColors.iconPrimary),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(AppDarkColors.iconPrimary),
        ),
      ),

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
        titleTextStyle: AppTextStyles.title.copyWith(
          color: AppDarkColors.textPrimary, // for dark theme
          height: 1,
        ), //same with title large
        iconTheme: const IconThemeData(color: AppDarkColors.iconPrimary),
      ),

      //=====Text theme=======
      textTheme: TextTheme(
        //title
        titleLarge: AppTextStyles.title.copyWith(
          color: AppDarkColors.textPrimary, // for dark theme
          // color: const Color(0xFF1F1A17),
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
          iconColor: AppDarkColors.iconPrimary,
          side: const BorderSide(color: AppDarkColors.amber),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          iconColor: AppDarkColors.iconPrimary,
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
        backgroundColor: AppDarkColors.darkSurfaceSolid,
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
      dividerColor: AppLightColors.textSecondary.withAlpha(50),
      iconTheme: IconThemeData(color: Colors.grey[800]),

      // ===== SLIDER =====
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppLightColors.primary,
        inactiveTrackColor: AppLightColors.border,
        thumbColor: AppLightColors.primary,
      ),

      //======Switch=======
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          // ON thumb
          if (states.contains(WidgetState.selected)) {
            return AppLightColors.switchThumbOn; // cocoa
          }
          // OFF thumb
          return AppLightColors.switchThumbOff;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          // ON track (bg)
          if (states.contains(WidgetState.selected)) {
            return AppLightColors.switchTrackOn;
          }
          // OFF track
          return AppLightColors.switchTrackOff;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          // OFF: show border
          if (!states.contains(WidgetState.selected)) {
            return AppLightColors.switchOutlineOn;
          }
          // ON: no border (looks cleaner)
          return Colors.transparent;
        }),
        trackOutlineWidth: WidgetStateProperty.resolveWith((states) {
          return 1.0; // keep thin
        }),
      ),

      // ===== BUTTONS =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppLightColors.buttonPrimary,
          foregroundColor: AppLightColors.buttonPrimaryText,
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
          backgroundColor: Colors.transparent, // optional, usually default
          foregroundColor: AppLightColors.buttonPrimary,
          iconColor: AppLightColors.iconPrimary,
          side: const BorderSide(color: AppLightColors.iconPrimary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          splashFactory: InkRipple.splashFactory, //splash
          overlayColor: AppLightColors.amber,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppLightColors.amber,
          iconColor: AppLightColors.iconPrimary,
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
