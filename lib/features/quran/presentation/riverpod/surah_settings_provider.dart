// Show/hide translation
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurahSettings {
  final bool showTranslation;
  final bool showTranslit;
  final bool showAutoScrollControls;
  final bool isAutoScrolling;
  final bool showAudioControls;
  final double arabicFontSize;
  final double translationFontSize;
  final double autoScrollSpeed; // ayahs per minute
  final bool mushafMode;

  const SurahSettings({
    required this.showTranslation,
    required this.showAutoScrollControls,
    required this.showAudioControls,
    required this.isAutoScrolling,
    required this.arabicFontSize,
    required this.translationFontSize,
    required this.autoScrollSpeed,
    required this.showTranslit,
    required this.mushafMode,
  });

  SurahSettings copyWith({
    bool? showTranslation,
    double? arabicFontSize,
    double? translationFontSize,
    double? autoScrollSpeed,
    bool? autoScrollEnabled,
    bool? showTranslit,
    bool? mushafMode,
    bool? isAutoScrolling,
    bool? showAutoScrollControls,
    bool? showAudioControls,
  }) {
    return SurahSettings(
      showTranslation: showTranslation ?? this.showTranslation,
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      translationFontSize: translationFontSize ?? this.translationFontSize,
      autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
      showTranslit: showTranslit ?? this.showTranslit,
      mushafMode: mushafMode ?? this.mushafMode,
      isAutoScrolling: isAutoScrolling ?? this.isAutoScrolling,
      showAudioControls: showAudioControls ?? this.showAudioControls,
      showAutoScrollControls:
          showAutoScrollControls ?? this.showAutoScrollControls,
    );
  }
}

final surahSettingsProvider =
    StateNotifierProvider<SurahSettingsNotifier, SurahSettings>(
      (ref) => SurahSettingsNotifier(),
    );

class SurahSettingsNotifier extends StateNotifier<SurahSettings> {
  SurahSettingsNotifier()
    : super(
        const SurahSettings(
          showTranslation: true,
          arabicFontSize: 24,
          translationFontSize: 16,
          autoScrollSpeed: 20,
          showTranslit: true,
          mushafMode: false,
          isAutoScrolling: false,
          showAudioControls: false,
          showAutoScrollControls: false,
        ),
      );

  void setShowTranslation(bool v) => state = state.copyWith(showTranslation: v);
  void setShowTranslit(bool v) => state = state.copyWith(showTranslit: v);

  void setMushafMode(bool v) => state = state.copyWith(mushafMode: v);

  void setArabicFont(double v) => state = state.copyWith(arabicFontSize: v);

  void setTranslationFont(double v) =>
      state = state.copyWith(translationFontSize: v);

  void setAutoScrollSpeed(double v) =>
      state = state.copyWith(autoScrollSpeed: v);

  void setAutoScroll(bool v) {
    if (state.showAutoScrollControls == v) return;
    state = state.copyWith(autoScrollEnabled: v);
  }

  void showAudioControls(bool v) {
    if (state.showAudioControls == v) return;
    debugPrint("✅✅✅ Setting controls to : $v");

    state = state.copyWith(showAudioControls: v);
  }

  void increaseSpeed() {
    state = state.copyWith(
      autoScrollSpeed: (state.autoScrollSpeed + 5).clamp(15, 120),
    );
  }

  void decreaseSpeed() {
    state = state.copyWith(
      autoScrollSpeed: (state.autoScrollSpeed - 5).clamp(15, 120),
    );
  }
}
