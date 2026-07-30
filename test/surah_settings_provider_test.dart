import 'package:flutter_test/flutter_test.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';

void main() {
  group('SurahSettingsNotifier', () {
    test('showAudioControls(true) updates the audio controls flag', () {
      final notifier = SurahSettingsNotifier();

      notifier.showAudioControls(true);

      expect(notifier.state.showAudioControls, isTrue);
    });

    test('copyWith preserves the requested audio controls flag', () {
      const initial = SurahSettings(
        showTranslation: true,
        showAutoScrollControls: false,
        showAudioControls: false,
        isAutoScrolling: false,
        arabicFontSize: 24,
        translationFontSize: 16,
        autoScrollSpeed: 20,
        showTranslit: true,
        mushafMode: false,
      );

      final updated = initial.copyWith(showAudioControls: true);

      expect(updated.showAudioControls, isTrue);
    });

    test('setAutoScroll(true) reveals the controls and starts scrolling', () {
      final notifier = SurahSettingsNotifier();

      notifier.setAutoScroll(true);

      expect(notifier.state.showAutoScrollControls, isTrue);
      expect(notifier.state.isAutoScrolling, isTrue);
    });

    test('setAutoScroll(false) hides the controls and stops scrolling', () {
      final notifier = SurahSettingsNotifier();

      notifier.setAutoScroll(true);
      notifier.setAutoScroll(false);

      expect(notifier.state.showAutoScrollControls, isFalse);
      expect(notifier.state.isAutoScrolling, isFalse);
    });
  });
}
