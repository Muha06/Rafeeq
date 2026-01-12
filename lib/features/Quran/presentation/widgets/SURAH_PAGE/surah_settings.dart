import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/surah_preferences_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class SurahSettingsSheet extends ConsumerWidget {
  const SurahSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return AnimatedSize(
      duration: Durations.medium3,
      curve: Curves.easeInOut,
      child: Consumer(
        builder: (context, ref, _) {
          final showTranslation = ref.watch(showTranslationProvider);
          final arabicFontSize = ref.watch(arabicFontSizeProvider);
          final translationFontSize = ref.watch(translationFontSizeProvider);

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Full Surah Settings',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 24),

                //TRANSATION TOGGLE & FONT SIZE
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppDarkColors.divider
                          : AppLightColors.divider,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Show/hide translation
                      SwitchListTile(
                        value: showTranslation,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Show Translation',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            // color: isDark ? Colors.white : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        onChanged: (value) {
                          ref.read(showTranslationProvider.notifier).state =
                              value;
                        },
                      ),

                      // Font size slider (Translation)
                      if (showTranslation) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Translation Font Size: ${translationFontSize.toInt()}',
                          style: theme.textTheme.bodySmall!.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        Slider(
                          min: 12,
                          max: 28,
                          value: translationFontSize,
                          onChanged: (value) {
                            ref
                                    .read(translationFontSizeProvider.notifier)
                                    .state =
                                value;
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Font size slider (Arabic)
                Text(
                  'Arabic Font Size: ${arabicFontSize.toInt()}',
                  style: theme.textTheme.bodySmall!.copyWith(fontSize: 16),
                ),
                Slider(
                  min: 16,
                  max: 36,
                  value: arabicFontSize,
                  onChanged: (value) {
                    ref.read(arabicFontSizeProvider.notifier).state = value;
                  },
                ),

                //divider
                Divider(color: theme.dividerColor),
                const SizedBox(height: 0),

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
          );
        },
      ),
    );
  }
}
