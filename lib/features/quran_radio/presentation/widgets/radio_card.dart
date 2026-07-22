import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/core/widgets/my_chip.dart';
import 'package:rafeeq/features/quran_radio/domain/enums/radio_audio_category.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/selected_station_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/widgets/category_fallback_image.dart';
import 'package:rafeeq/features/quran_radio/presentation/widgets/radio_player_sheet.dart';
import '../../domain/entities/radio_station.dart';

class RadioCard extends ConsumerStatefulWidget {
  final RadioStation station;

  const RadioCard({super.key, required this.station});

  @override
  ConsumerState<RadioCard> createState() => _RadioCardState();
}

class _RadioCardState extends ConsumerState<RadioCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final selected = ref.watch(currentStationProvider);
    final isSelected = selected == widget.station;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        await AppSheets.showBottomSheet(
          context: context,
          useSafeArea: false,
          isScrollControlled: true,
          child: RadioPlayerSheet(station: widget.station),
        );

        ref.read(currentStationProvider.notifier).state = widget.station;
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? cs.primary.withAlpha(64) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // IMAGE
            SizedBox(
              height: 100,
              width: 100,
              child: widget.station.imageUrl != null
                  ? AppCachedImage(
                      imageUrl: widget.station.imageUrl,
                      shape: AppImageShape.circle,
                      fit: BoxFit.cover,
                    )
                  : CategoryFallback(
                      station: widget.station,
                      height: 80,
                      width: 80,
                      isSheet: false,
                      showShadow: false,
                    ),
            ),

            const SizedBox(height: 8),

            // TEXT SECTION
            Text(
              widget.station.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface),
            ),

            const SizedBox(height: 6),

            // TAG
            MyChip(
              child: Text(
                widget.station.category.label,
                style: theme.textTheme.labelSmall!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
