import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';

class RadioCategorySelector extends StatelessWidget {
  const RadioCategorySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final RadioAudioCategory selected;
  final ValueChanged<RadioAudioCategory> onChanged;

  IconData _icon(RadioAudioCategory c) {
    switch (c) {
      case RadioAudioCategory.quran:
        return PhosphorIcons.bookOpen();
      case RadioAudioCategory.hadith:
        return PhosphorIcons.chatCenteredText();
      case RadioAudioCategory.tafsir:
        return PhosphorIcons.magnifyingGlass();
      case RadioAudioCategory.adhkar:
        return PhosphorIcons.sun();
      case RadioAudioCategory.seerah:
        return PhosphorIcons.person();
      case RadioAudioCategory.fiqh:
        return PhosphorIcons.scales();
      case RadioAudioCategory.qisas:
        return PhosphorIcons.bookBookmark();
      case RadioAudioCategory.fatwa:
        return PhosphorIcons.question();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: RadioAudioCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = RadioAudioCategory.values[index];
          final selectedCat = cat == selected;

          return GestureDetector(
            onTap: () => onChanged(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: selectedCat ? cs.primaryContainer : cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedCat
                      ? cs.primary
                      : cs.onSurfaceVariant.withAlpha(120),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _icon(cat),
                    size: 18,
                    color: selectedCat ? cs.onPrimaryContainer : cs.onSurface,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: selectedCat ? cs.onPrimaryContainer : cs.onSurface,
                      fontWeight: selectedCat
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
