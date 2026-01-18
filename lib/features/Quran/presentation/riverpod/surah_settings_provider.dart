// Show/hide translation
import 'package:riverpod/legacy.dart';

class SurahSettings {
  final bool showTranslation;
  final double arabicFontSize;
  final double translationFontSize;
  final double autoScrollSpeed; // ayahs per minute

  const SurahSettings({
    required this.showTranslation,
    required this.arabicFontSize,
    required this.translationFontSize,
    required this.autoScrollSpeed,
  });

  SurahSettings copyWith({
    bool? showTranslation,
    double? arabicFontSize,
    double? translationFontSize,
    double? autoScrollSpeed,
  }) {
    return SurahSettings(
      showTranslation: showTranslation ?? this.showTranslation,
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      translationFontSize: translationFontSize ?? this.translationFontSize,
      autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
    );
  }
}

class SurahSettingsNotifier extends StateNotifier<SurahSettings> {
  SurahSettingsNotifier()
    : super(
        const SurahSettings(
          showTranslation: true,
          arabicFontSize: 24,
          translationFontSize: 16,
          autoScrollSpeed: 20,
        ),
      );

  void setShowTranslation(bool v) => state = state.copyWith(showTranslation: v);

  void setArabicFont(double v) => state = state.copyWith(arabicFontSize: v);

  void setTranslationFont(double v) =>
      state = state.copyWith(translationFontSize: v);

  void setAutoScrollSpeed(double v) =>
      state = state.copyWith(autoScrollSpeed: v);
}

final surahSettingsProvider =
    StateNotifierProvider<SurahSettingsNotifier, SurahSettings>(
      (ref) => SurahSettingsNotifier(),
    );
