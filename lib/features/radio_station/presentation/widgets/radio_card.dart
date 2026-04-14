import 'package:flutter/material.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/core/widgets/my_chip.dart';
import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';
import 'package:rafeeq/features/radio_station/presentation/widgets/radio_player_sheet.dart';
import '../../domain/entities/radio_station.dart';

class RadioCard extends StatelessWidget {
  final RadioStation station;

  const RadioCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => AppSheets.showBottomSheet(
        context: context,
        showDragHandle: false,
        useSafeArea: false,
        isScrollControlled: true,
        child: RadioPlayerSheet(station: station),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Expanded(
              child: AppCachedImage(
                imageUrl: station.imageUrl,
                height: 80,
                width: double.infinity,
              ),
            ),

            // TEXT SECTION
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge,
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
          ],
        ),
      ),
    );
  }
}
