import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class SurahSettingsSheet extends ConsumerStatefulWidget {
  const SurahSettingsSheet({super.key});
  @override
  ConsumerState<SurahSettingsSheet> createState() => _SurahSettingsSheetState();
}

class _SurahSettingsSheetState extends ConsumerState<SurahSettingsSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    final s = ref.watch(surahSettingsProvider);
    final sNotifier = ref.read(surahSettingsProvider.notifier);

    final showTranslation = ref.watch(
      surahSettingsProvider.select((s) => s.showTranslation),
    );
    final arabicFontSize = ref.watch(
      surahSettingsProvider.select((s) => s.arabicFontSize),
    );
    final translationSize = ref.watch(
      surahSettingsProvider.select((s) => s.translationFontSize),
    );
    final speed = ref.watch(
      surahSettingsProvider.select((s) => s.autoScrollSpeed),
    );

    final titleTextstyle = theme.textTheme.labelLarge!.copyWith(
      fontSize: 19,
      fontWeight: FontWeight.w300,
    );

    return AnimatedSize(
      duration: Durations.medium3,
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            Text('Full Surah Settings', style: theme.textTheme.titleMedium),
            const SizedBox(height: 24),

            //TRANSATION TOGGLE & FONT SIZE
            _buildSettingBorder(
              isDark: isDark,
              children: [
                // Show/hide translation
                SwitchListTile(
                  value: showTranslation,
                  contentPadding: EdgeInsets.zero,
                  title: Text('Show Translation', style: titleTextstyle),
                  onChanged: (value) {
                    sNotifier.setShowTranslation(value);
                  },
                ),

                // Font size slider (Translation)
                if (s.showTranslation) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Translation Font Size: ${translationSize.toInt()}',
                    style: titleTextstyle,
                  ),
                  Slider(
                    min: 12,
                    max: 28,
                    value: translationSize,
                    onChanged: (value) {
                      sNotifier.setTranslationFont(value);
                    },
                  ),
                ],
              ],
            ),

            // Font size slider (Arabic)
            _buildSettingBorder(
              isDark: isDark,
              children: [
                Text(
                  'Arabic Font Size: ${arabicFontSize.toInt()}',
                  style: titleTextstyle,
                ),
                Slider(
                  min: 16,
                  max: 36,
                  value: arabicFontSize,
                  onChanged: (value) {
                    sNotifier.setArabicFont(value);
                  },
                ),
              ],
            ),

            _buildSettingBorder(
              isDark: isDark,
              children: [
                Text('Auto-scroll speed', style: titleTextstyle),
                Slider(
                  min: 10,
                  max: 120,
                  divisions: 15,
                  value: speed,
                  label: '${speed.round()} px/s',
                  onChanged: (value) {
                    sNotifier.setAutoScrollSpeed(value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 4),

            //cancel btn
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

Widget _buildSettingBorder({
  required bool isDark,
  required List<Widget> children,
}) {
  return Container(
    // padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...children,
        // Divider(color: isDark ? AppDarkColors.divider : AppLightColors.divider),
      ],
    ),
  );
}
