import 'package:flutter/material.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/core/widgets/my_chip.dart';
import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';
import 'package:rafeeq/features/radio_station/presentation/widgets/category_fallback_image.dart';
import 'package:rafeeq/features/radio_station/presentation/widgets/radio_player_sheet.dart';
import '../../domain/entities/radio_station.dart';

class RadioCard extends StatelessWidget {
  final RadioStation station;

  const RadioCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
         ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // IMAGE
            SizedBox(
              height: 80,
              width: 80,
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
