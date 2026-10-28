import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/constants/spacing/app_spacing.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/core/widgets/app_edge_fade.dart';
import 'package:rafeeq/core/widgets/app_icon_container.dart';
import 'package:rafeeq/features/quran_radio/domain/entities/radio_station.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/radio_favs_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/widgets/category_fallback_image.dart';

class FavoriteStationsSection extends ConsumerWidget {
  const FavoriteStationsSection({super.key, required this.onStationTap});

  /// Receives the whole favorites list and the tapped index, so the
  /// player's prev/next stays inside favorites.
  final void Function(List<RadioStation> stations, int index) onStationTap;

  static const double _gap = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteStationsProvider);
    if (favorites.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
            ),
            child: Row(
              children: [
                Text('Favorites', style: tt.titleLarge),
                const SizedBox(width: 8),

                AppIconContainer(
                  size: 28,
                  borderRadius: 999,
                  backgroundColor: cs.surface,
                  child: Text(
                    '${favorites.length}',
                    style: tt.titleSmall?.copyWith(color: cs.onSurface),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          AppEdgeFade(
            fadeStart: false,
            fadeLength: 32,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              child: Row(
                children: [
                  for (var i = 0; i < favorites.length; i++)
                    Padding(
                      key: ValueKey(favorites[i].id),
                      padding: const EdgeInsets.only(right: _gap),
                      child: FavoriteStationCard(
                        stations: favorites,
                        initialIndex: i,
                        onTap: () => onStationTap(favorites, i),
                        onLongPress: () {
                          AppSheets.showConfirmSheet(
                            context: context,
                            icon: HugeIconsSolid.delete02,
                            title: 'Remove from Favorites?',
                            description: 'Are you sure you want to remove this station from your favorites?',
                            confirmText: 'Remove',
                            useSafeArea: true,
                            destructive: true,
                            onConfirm: () async {
                              AppNav.pop(context);

                              await ref
                                  .read(radioFavoritesProvider.notifier)
                                  .toggle(favorites[i].id);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}

class FavoriteStationCard extends ConsumerWidget {
  const FavoriteStationCard({
    super.key,
    required this.stations,
    required this.initialIndex,
    required this.onTap,
    required this.onLongPress,
    this.width = 132,
    this.height = 158,
  });

  final List<RadioStation> stations;
  final int initialIndex;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final double width;
  final double height;

  static const double _radius = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    final station = stations[initialIndex];

    final isPlaying = ref.watch(
      audioControllerProvider.select(
        (s) => s.currentId == station.id && s.isPlaying,
      ),
    );

    return Container(
      width: width,
      height: height,
      // Outline is drawn above the image so it's never covered.
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Artwork fills the card
              AppCachedImage(
                imageUrl: station.imageUrl,
                height: height,
                width: width,
                borderRadius: 0,
                errorWidget: CategoryFallback(
                  station: station,
                  showShadow: false,
                  height: height,
                  width: width,
                ),
                placeholder: SizedBox(height: height, width: width),
              ),

              // Bottom gradient so the text is always readable
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.35, 1.0],
                    colors: [Color(0x00000000), Color(0xE6000000)],
                  ),
                ),
              ),

              // Playing pill (top-left)
              if (isPlaying)
                Positioned(
                  top: 10,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x99000000),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.graphic_eq_rounded,
                          size: 14,
                          color: cs.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Playing',
                          style: tt.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Category + name
              Positioned(
                left: 12,
                right: 12,
                bottom: 18,
                child: Text(
                  station.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleMedium?.copyWith(
                    fontFamily: AppStrings.displayFont,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
