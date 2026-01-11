import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/surah_preferences_provider.dart';

class SurahSettingsSheet extends StatelessWidget {
  const SurahSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer(
      builder: (context, ref, _) {
        final showTranslation = ref.watch(showTranslationProvider);
        final arabicFontSize = ref.watch(arabicFontSizeProvider);
        final translationFontSize = ref.watch(translationFontSizeProvider);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: 6,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppDarkColors.textSecondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: Text(
                  'Full Surah Settings',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 16),

              Divider(color: theme.dividerColor),
              const SizedBox(height: 16),

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
                  ref.read(showTranslationProvider.notifier).state = value;
                },
              ),

              const SizedBox(height: 8),

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

              // Font size slider (Translation)
              if (showTranslation) ...[
                Text(
                  'Translation Font Size: ${translationFontSize.toInt()}',
                  style: theme.textTheme.bodySmall!.copyWith(fontSize: 16),
                ),
                Slider(
                  min: 12,
                  max: 28,
                  value: translationFontSize,
                  onChanged: (value) {
                    ref.read(translationFontSizeProvider.notifier).state =
                        value;
                  },
                ),
              ],

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
            ],
          ),
        );
      },
    );
  }
}
