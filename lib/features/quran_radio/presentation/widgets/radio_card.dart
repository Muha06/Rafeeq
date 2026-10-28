import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
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

  static const double _imageSize = 84;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final station = stations[initialIndex];
    final hasImage = station.imageUrl != null && station.imageUrl!.isNotEmpty;

    final isSelected = ref.watch(currentStationProvider)?.id == station.id;
    final isPlaying = ref.watch(
      audioControllerProvider.select(
        (s) => s.currentId == station.id && s.isPlaying,
      ),
    );

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

        AppSheets.showBottomSheet(
          context: context,
          isScrollControlled: true,
          clipBehavior: Clip.hardEdge,
          useSafeArea: false,
          animationDuration: const Duration(milliseconds: 400),
          reverseAnimationDuration: const Duration(milliseconds: 300),
          child: RadioPlayerSheet(
            stations: stations,
            initialIndex: initialIndex,
          ),
        );
      },
      child: RepaintBoundary(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // IMAGE: ring + glow + playing badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Constant width so the card never changes size.
                      border: Border.all(
                        color: isSelected
                            ? cs.primary
                            : cs.outlineVariant.withAlpha(90),
                        width: 1.5,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: cs.primary.withAlpha(70),
                            blurRadius: 18,
                            spreadRadius: 1,
                          ),
                      ],
                    ),
                    child: hasImage
                        ? AppCachedImage(
                            imageUrl: station.imageUrl,
                            height: _imageSize,
                            width: _imageSize,
                            shape: AppImageShape.circle,
                            placeholder: Container(
                              height: _imageSize,
                              width: _imageSize,
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHighest,
                              ),
                            ),
                            fit: BoxFit.cover,
                          )
                        : ClipOval(
                            child: CategoryFallback(
                              station: station,
                              height: _imageSize,
                              width: _imageSize,
                            ),
                          ),
                  ),

                  // Playing badge (pops in/out)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: AnimatedScale(
                      scale: isPlaying ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutBack,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.surface, width: 2),
                        ),
                        child: Icon(
                          Icons.graphic_eq_rounded,
                          size: 14,
                          color: cs.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // TEXT SECTION
              Text(
                station.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected ? cs.primary : cs.onSurface,
                  fontSize: 13,
                  height: 1.25,
                  fontWeight: isSelected ? FontWeight.w600 : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
