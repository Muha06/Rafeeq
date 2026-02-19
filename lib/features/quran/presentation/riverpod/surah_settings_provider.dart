// Show/hide translation
import 'package:riverpod/legacy.dart';

class SurahSettings {
  final bool showTranslation;
  final bool showTranslit;
  final double arabicFontSize;
  final double translationFontSize;
  final double autoScrollSpeed; // ayahs per minute
  final bool autoScrollEnabled;

  const SurahSettings({
    required this.showTranslation,
    required this.arabicFontSize,
    required this.translationFontSize,
    required this.autoScrollSpeed,
    required this.autoScrollEnabled,
    required this.showTranslit
  });

  SurahSettings copyWith({
    bool? showTranslation,
    double? arabicFontSize,
    double? translationFontSize,
    double? autoScrollSpeed,
    bool? autoScrollEnabled,
    bool? showTranslit
  }) {
    return SurahSettings(
      showTranslation: showTranslation ?? this.showTranslation,
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      translationFontSize: translationFontSize ?? this.translationFontSize,
      autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
      autoScrollEnabled: autoScrollEnabled ?? this.autoScrollEnabled,
      showTranslit: showTranslit?? this.showTranslit
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
          autoScrollEnabled: false,
          showTranslit: true
        ),
      );

  void setShowTranslation(bool v) => state = state.copyWith(showTranslation: v);
  void setShowTranslit(bool v) => state = state.copyWith(showTranslit: v);

  void setArabicFont(double v) => state = state.copyWith(arabicFontSize: v);

  void setTranslationFont(double v) =>
      state = state.copyWith(translationFontSize: v);

  void setAutoScrollSpeed(double v) =>
      state = state.copyWith(autoScrollSpeed: v);

  void setAutoScrollEnabled(bool v) {
    if (state.autoScrollEnabled == v) return;
    state = state.copyWith(autoScrollEnabled: v);
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
