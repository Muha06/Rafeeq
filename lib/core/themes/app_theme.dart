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
          iconColor: WidgetStatePropertyAll(AppDarkColors.iconSecondary),
        ),
      ),

      colorScheme: const ColorScheme.dark(
        surface: AppDarkColors
            .darkSurface, //change to bgcolor hide the navigation colors
        onSurface: AppDarkColors.onDarkSurface,
        primary: AppDarkColors.darkBackground,
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
        // Big screen/page titles (Home, Quran, Settings)
        titleLarge: AppTextStyles.title.copyWith(
          color: AppDarkColors.textPrimary,
        ),

        // Card titles / section headers
        titleMedium: AppTextStyles.section.copyWith(
          color: AppDarkColors.textPrimary,
        ),

        // Small headings (like "Daily verse", "Explore")
        titleSmall: AppTextStyles.section.copyWith(
          color: AppDarkColors.textSecondary,
        ),

        // Qur'an Arabic (Uthmani)
        bodyLarge: AppTextStyles.quranBody.copyWith(
          color: AppDarkColors.textPrimary.withAlpha(224), // ~0.88
        ),

        // Main body text (most content)
        bodyMedium: AppTextStyles.paragraph.copyWith(
          color: AppDarkColors.textPrimary,
        ),

        // Captions / metadata (date, references)
        bodySmall: AppTextStyles.secondary.copyWith(
          color: AppDarkColors.textSecondary.withAlpha(199), // ~0.78
        ),

        // Chips, small UI labels (“Tap to read”, times)
        labelMedium: AppTextStyles.label.copyWith(
          color: AppDarkColors.textPrimary.withAlpha(217), // ~0.85
        ),
        labelSmall: AppTextStyles.label.copyWith(
          color: AppDarkColors.textSecondary.withAlpha(191), // ~0.75
        ),
      ),

      //CARD
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withAlpha(60),
        color: AppDarkColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        strokeWidth: 3.5,
        color: AppDarkColors.amber,
      ),

      sliderTheme: const SliderThemeData(
        activeTrackColor: AppDarkColors.amber,
        thumbColor: AppDarkColors.amber,
        inactiveTrackColor: AppDarkColors.textSecondary,
      ),

      // ===== BUTTON THEME =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDarkColors.buttonPrimary,
          foregroundColor: AppDarkColors.darkBackground,
          iconColor: AppDarkColors.darkBackground,
          disabledBackgroundColor: AppDarkColors.buttonDisabled,
          disabledForegroundColor: AppDarkColors.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      filledButtonTheme: const FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Color(0xCC293A41)),
          foregroundColor: WidgetStatePropertyAll(AppDarkColors.amber),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      ),

      //======Switch=======
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppDarkColors.switchThumbDisabled;
          }
          if (states.contains(WidgetState.selected)) {
            return AppDarkColors.teal;
          }
          return AppDarkColors.switchThumbOff;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppDarkColors.switchTrackDisabled;
          }
          if (states.contains(WidgetState.selected)) {
            return AppDarkColors.switchTrackOn;
          }
          return AppDarkColors.switchTrackOff;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppDarkColors.switchOutlineDisabled;
          }
          if (states.contains(WidgetState.selected)) {
            return AppDarkColors.switchOutlineOn;
          }
          return AppDarkColors.switchOutlineOff;
        }),
        overlayColor: WidgetStateProperty.all(AppDarkColors.switchOverlay),
        splashRadius: 14,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(4),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppDarkColors.amber,
          iconColor: AppDarkColors.iconPrimary,
          side: const BorderSide(color: AppDarkColors.iconDisabled),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          iconColor: AppDarkColors.iconPrimary,
          foregroundColor: AppDarkColors.textPrimary,
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
        backgroundColor: AppDarkColors.bottomSheet,
        showDragHandle: true,
        dragHandleColor: AppDarkColors.iconDisabled,
        dragHandleSize: Size(48, 4),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppDarkColors.darkSurface.withAlpha(255),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppDarkColors.divider),
        ),
        titleTextStyle: AppTextStyles.title,
      ),

      //textfield
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppDarkColors.iconSecondary,
        selectionColor: AppDarkColors.amberSoft,
        selectionHandleColor: AppDarkColors.amber,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppDarkColors.darkSurface,
        iconColor: AppDarkColors.iconSecondary,
        prefixIconColor: AppDarkColors.iconSecondary,

        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        constraints: const BoxConstraints(minHeight: 36),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),

        hintStyle: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w300,
          height: 1,
          fontSize: 16,
          color: AppDarkColors.textSecondary,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
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
        // Page / AppBar titles
        titleLarge: AppTextStyles.title.copyWith(
          color: AppLightColors.textPrimary,
        ),

        // Qur’an Arabic (Uthmani) — bodyLarge (as you requested)
        bodyLarge: AppTextStyles.quranBody.copyWith(
          color: AppLightColors.textPrimary,
        ),

        // Translation / paragraph / general content — bodyMedium
        bodyMedium: AppTextStyles.paragraph.copyWith(
          color: AppLightColors.textPrimary, // ~0.88
        ),

        // Small / caption text
        bodySmall: AppTextStyles.secondary.copyWith(
          color: AppLightColors.textSecondary.withAlpha(199), // ~0.78
        ),

        //labels (chips, times, "Tap to read")
        labelMedium: AppTextStyles.label.copyWith(
          color: AppLightColors.textPrimary.withAlpha(217), // ~0.85
        ),
        labelSmall: AppTextStyles.label.copyWith(
          color: AppLightColors.textSecondary.withAlpha(191), // ~0.75
        ),

        // Optional: section headers (Daily verse, Explore)
        titleMedium: AppTextStyles.section.copyWith(
          color: AppLightColors.textPrimary,
        ),
        titleSmall: AppTextStyles.section.copyWith(
          color: AppLightColors.textSecondary,
        ),
      ),

      cardColor: AppLightColors.lightSurface,
      dividerColor: AppLightColors.textSecondary.withAlpha(50),
      iconTheme: IconThemeData(color: Colors.grey[800]),
      chipTheme: const ChipThemeData(surfaceTintColor: Colors.transparent),

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
          return 1.0;
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
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppLightColors.buttonPrimary),
            borderRadius: BorderRadius.circular(999),
          ),
          foregroundColor: AppLightColors.buttonPrimary,
          iconColor: AppLightColors.iconPrimary,
          side: const BorderSide(color: AppLightColors.iconPrimary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          splashFactory: InkRipple.splashFactory, //splash
          overlayColor: AppLightColors.amber,
        ),
      ),

      filledButtonTheme: const FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppLightColors.buttonPrimary),
          foregroundColor: WidgetStatePropertyAll(
            AppLightColors.buttonPrimaryText,
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppLightColors.textPrimary,
          iconColor: AppLightColors.iconPrimary,
          overlayColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          padding: EdgeInsets.zero, // remove all padding
          minimumSize: Size.zero, // optional: remove minimum size
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // shrink tap area
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppLightColors.lightSurface,
        iconColor: AppLightColors.iconPrimary,
        prefixIconColor: AppLightColors.iconPrimary,

        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        constraints: const BoxConstraints(minHeight: 36),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),

        hintStyle: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w300,
          height: 1,
          fontSize: 16,
          color: AppLightColors.textSecondary,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        backgroundColor: AppLightColors.lightBackground,
        showDragHandle: true,
        dragHandleColor: AppDarkColors.onDarkSurface,
        dragHandleSize: Size(48, 6),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppLightColors.lightBackground,
        surfaceTintColor: Colors.transparent, // removes M3 tint "wash"
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppLightColors.divider),
        ),
        titleTextStyle: AppTextStyles.title,
      ),
    );
  }
}
