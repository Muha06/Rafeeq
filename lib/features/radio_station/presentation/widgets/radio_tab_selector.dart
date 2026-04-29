import 'package:flutter/material.dart';
 import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';

class RadioCategorySelector extends StatelessWidget {
  const RadioCategorySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final RadioAudioCategory selected;
  final ValueChanged<RadioAudioCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: RadioAudioCategory.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
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
                    selected.icon,
                    size: 18,
                    color: selectedCat ? cs.onPrimaryContainer : cs.onSurface,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat.label,
                    style: tt.labelMedium!.copyWith(
                      color: selectedCat ? cs.onPrimaryContainer : cs.onSurface,
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
