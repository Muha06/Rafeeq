import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/widgets/reciter_picker_sheet.dart';

class SurahSettingsSheet extends ConsumerStatefulWidget {
  const SurahSettingsSheet({super.key, required this.onAutoScrollChanged});
  final ValueChanged<bool> onAutoScrollChanged;
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

    final showTranslit = ref.watch(
      surahSettingsProvider.select((s) => s.showTranslit),
    );

    final arabicFontSize = ref.watch(
      surahSettingsProvider.select((s) => s.arabicFontSize),
    );
    final translationSize = ref.watch(
      surahSettingsProvider.select((s) => s.translationFontSize),
    );

    final autoScrollEnabled = ref.watch(
      surahSettingsProvider.select((s) => s.showAutoScrollControls),
    );

    final titleTextstyle = theme.listTileTheme.titleTextStyle;
    final valueTextstyle = theme.textTheme.bodyMedium;

    final selectedReciter = ref.watch(selectedReciterProvider);

    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppDragHandle(),

            //Auto scroll
            SwitchListTile(
              title: Text('Auto scroll', style: titleTextstyle),
              value: autoScrollEnabled,
              contentPadding: EdgeInsets.zero,
              onChanged: (v) {
                sNotifier.setAutoScroll(v);
                widget.onAutoScrollChanged(v);
                if (v) {
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 4),

            //TRANSATION TOGGLE
            SwitchListTile(
              value: showTranslation,
              contentPadding: EdgeInsets.zero,
              title: Text('Show Translation', style: titleTextstyle),
              onChanged: (value) {
                sNotifier.setShowTranslation(value);
              },
            ),
            const SizedBox(height: 4),

            SwitchListTile(
              value: showTranslit,
              contentPadding: EdgeInsets.zero,
              title: Text('Show Transliteration', style: titleTextstyle),
              onChanged: (value) {
                sNotifier.setShowTranslit(value);
              },
            ),
            const SizedBox(height: 4),

            const SizedBox(height: 4),

            //select reciter
            _SurahSettingsSelectTile(
              title: 'Reciters',
              value: selectedReciter.name,
              valueStyle: valueTextstyle,
              onTap: () {
                AppSheets.showBottomSheet(
                  context: context,
                  child: const ReciterPickerSheet(),
                );
              },
            ),

            const SizedBox(height: 4),

            // Font size slider (Arabic)
            _LabelValueRow(
              label: 'Arabic font size: ',
              value: arabicFontSize.toInt().toString(),
              labelStyle: titleTextstyle!,
              valueStyle: valueTextstyle!,
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
              _LabelValueRow(
                label: 'Translation fontsize: ',
                value: translationSize.toInt().toString(),
                labelStyle: titleTextstyle,
                valueStyle: valueTextstyle,
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
      ),
    );
  }
}

class _LabelValueRow extends StatelessWidget {
  const _LabelValueRow({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _SurahSettingsSelectTile extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final double? maxValueWidth;
  final VoidCallback onTap;

  const _SurahSettingsSelectTile({
    required this.title,
    required this.value,
    required this.onTap,
    this.titleStyle,
    this.valueStyle,
    this.maxValueWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: titleStyle),
      trailing: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxValueWidth ?? double.infinity),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: valueStyle ?? theme.textTheme.labelLarge,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
