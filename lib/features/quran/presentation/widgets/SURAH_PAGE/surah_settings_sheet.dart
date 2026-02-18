import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/widgets/reciter_picker_sheet.dart';

class SurahSettingsSheet extends ConsumerStatefulWidget {
  const SurahSettingsSheet({super.key, required this.onToggleAutoScroll});
  final VoidCallback onToggleAutoScroll;
  @override
  ConsumerState<SurahSettingsSheet> createState() => _SurahSettingsSheetState();
}

class _SurahSettingsSheetState extends ConsumerState<SurahSettingsSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
 
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

    final autoScrollEnabled = ref.watch(
      surahSettingsProvider.select((s) => s.autoScrollEnabled),
    );

    final titleTextstyle = theme.textTheme.labelLarge!.copyWith(fontSize: 18);

    final selectedReciter = ref.watch(selectedReciterProvider);

    return AnimatedSize(
      duration: Durations.medium3,
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //Auto scroll
            SwitchListTile(
              title: Text('Auto scroll', style: titleTextstyle),
              value: autoScrollEnabled,
              contentPadding: EdgeInsets.zero,
              onChanged: (v) {
                sNotifier.setAutoScrollEnabled(v);
                widget.onToggleAutoScroll();
                if (v) {
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 4),

            //TRANSATION TOGGLE & FONT SIZE
            SwitchListTile(
              value: showTranslation,
              contentPadding: EdgeInsets.zero,
              title: Text('Show Translation', style: titleTextstyle),
              onChanged: (value) {
                sNotifier.setShowTranslation(value);
              },
            ),

            const SizedBox(height: 4),

            //select reciter
            ListTile(
              title: Text('Reciters', style: titleTextstyle),
              contentPadding: EdgeInsets.zero,
              trailing: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        selectedReciter.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const FaIcon(FontAwesomeIcons.chevronRight, size: 16),
                  ],
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const ReciterPickerSheet(),
                );
              },
            ),

            const SizedBox(height: 4),

            // Font size slider (Arabic)
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
          ],
        ),
      ),
    );
  }
}
