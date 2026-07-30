import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/features/quran_radio/domain/entities/radio_context.dart';
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

        if (!context.mounted) return;

        Navigator.of(context).push(
          ModalBottomSheetRoute(
            isScrollControlled: true,
            clipBehavior: Clip.hardEdge,
            sheetAnimationStyle: const AnimationStyle(
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 300),
            ),
            showDragHandle: false,
            builder: (context) {
              return RadioPlayerSheet(
                stations: stations,
                initialIndex: initialIndex,
              );
            },
          ),
        );
      },
      child: RepaintBoundary(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            // color: isSelected ? cs.primary.withAlpha(64) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // IMAGE
              station.imageUrl == null || station.imageUrl!.isEmpty
                  ? CategoryFallback(station: station, height: 84, width: 84)
                  : AppCachedImage(
                      imageUrl: station.imageUrl,
                      height: 84,
                      width: 84,
                      shape: AppImageShape.circle,
                      placeholder: Container(
                        height: 84,
                        width: 84,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),

              const SizedBox(height: 8),

              // TEXT SECTION
              Text(
                station.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected ? cs.primary : cs.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
