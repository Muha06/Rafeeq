import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/core/widgets/my_chip.dart';
import 'package:rafeeq/features/quran_radio/domain/entities/radio_context.dart';
import 'package:rafeeq/features/quran_radio/domain/enums/radio_audio_category.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/radio_context_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/selected_station_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/widgets/category_fallback_image.dart';
import 'package:rafeeq/features/quran_radio/presentation/widgets/radio_player_sheet.dart';
import '../../domain/entities/radio_station.dart';

class RadioCard extends ConsumerWidget {
  const RadioCard({
    super.key,
    required this.stations,
    required this.initialIndex,
  });

  final List<RadioStation> stations;
  final int initialIndex;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final station = stations[initialIndex];

    final isSelected = ref.watch(currentStationProvider)?.id == station.id;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
         ref
            .read(radioPlaybackSessionProvider.notifier)
            .state = RadioPlaybackSession(
          stations: stations,
          currentIndex: initialIndex,
        );

        AppSheets.showBottomSheet(
          context: context,
          useSafeArea: false,
          isScrollControlled: true,
          child: RadioPlayerSheet(
            stations: stations,
            initialIndex: initialIndex,
          ),
        );
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
              child: station.imageUrl != null
                  ? AppCachedImage(
                      imageUrl: station.imageUrl,
                      shape: AppImageShape.circle,
                      fit: BoxFit.cover,
                    )
                  : CategoryFallback(
                      station: station,
                      height: 80,
                      width: 80,
                      isSheet: false,
                      showShadow: false,
                    ),
            ),

            const SizedBox(height: 8),

            // TEXT SECTION
            Text(
              station.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface),
            ),

            const SizedBox(height: 6),

            // TAG
            MyChip(
              child: Text(
                station.category.label,
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
