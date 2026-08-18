import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/app_keys.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_source_type.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/presentation/widgets/seek_bar.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/quran_audio_sheet.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/radio_context_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/selected_station_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/widgets/radio_player_sheet.dart';
import 'package:text_scroll/text_scroll.dart';

class GLobalMiniPlayerSheet extends ConsumerStatefulWidget {
  const GLobalMiniPlayerSheet({super.key});

  @override
  ConsumerState<GLobalMiniPlayerSheet> createState() =>
      _GLobalMiniPlayerSheetState();
}

class _GLobalMiniPlayerSheetState extends ConsumerState<GLobalMiniPlayerSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final isPlaying = ref.watch(
      audioControllerProvider.select((s) => s.isPlaying),
    );

    final isBuffering = ref.watch(
      audioControllerProvider.select((s) => s.isBuffering),
    );

    final title = ref.watch(audioControllerProvider.select((s) => s.title));
    final imageUrl = ref.watch(
      audioControllerProvider.select((s) => s.imageUrl),
    );
    final sourceType = ref.watch(
      audioControllerProvider.select((s) => s.sourceType),
    );
    final artist = ref.watch(audioControllerProvider.select((s) => s.artist));

    final ctrl = ref.read(audioControllerProvider.notifier);
    final onSeek = ctrl.seek;

    final session = ref.watch(radioPlaybackSessionProvider);

    final controlsIconSize = 24.0;
    debugPrint("Mini player rebuilt");

    return SafeArea(
      top: false,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          switch (sourceType) {
            case AudioSourceType.quranSurah:
              AppSheets.showBottomSheet(
                context: context,
                isScrollControlled: true,
                clipBehavior: Clip.hardEdge,
                useSafeArea: false,
                animationDuration: const Duration(milliseconds: 400),
                child: const QuranAudioSheet(),
              );
              break;

            case AudioSourceType.quranRadio:
              if (session == null) return;

              AppSheets.showBottomSheet(
                context: context,
                useSafeArea: false,
                isScrollControlled: true,
                child: RadioPlayerSheet(
                  stations: session.stations,
                  initialIndex: session.currentIndex,
                ),
              );

              break;

            default:
              break;
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: cs.surfaceContainerHighest,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (imageUrl != null) ...[
                      AppCachedImage(
                        imageUrl: imageUrl,
                        height: 48,
                        width: 48,
                        shape: AppImageShape.circle,
                        borderRadius: 12,
                      ),
                    ] else ...[
                      const Icon(HugeIconsSolid.audioWave01),
                    ],
                    const SizedBox(width: 12),

                    // Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextScroll(
                            key: ValueKey(sourceType),
                            title ?? 'Now playing',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontSize: 14,
                            ),
                          ),

                          // Artist
                          if (artist != null)
                            SizedBox(
                              width: double.infinity,
                              child: TextScroll(
                                "🎧 $artist",
                                mode: TextScrollMode.endless,
                                intervalSpaces: 16,
                                velocity: const Velocity(
                                  pixelsPerSecond: Offset(20, 0),
                                ),
                                textAlign: TextAlign.left,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    isBuffering
                        ? const CupertinoActivityIndicator()
                        : IconButton(
                            onPressed: isBuffering
                                ? null
                                : () => isPlaying ? ctrl.pause() : ctrl.play(),
                            icon: Icon(
                              isPlaying
                                  ? HugeIconsStroke.pause
                                  : PhosphorIcons.play,
                              size: controlsIconSize,
                              color: cs.onSurface,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),

                    //stop
                    IconButton(
                      onPressed: () {
                        ref.read(currentStationProvider.notifier).state = null;

                        ref.read(radioPlaybackSessionProvider.notifier).state =
                            null;

                        ctrl.stop();
                        scaffoldMessengerKey.currentState
                            ?.hideCurrentSnackBar();
                      },
                      icon: Icon(
                        HugeIconsStroke.cancel01,
                        size: controlsIconSize,
                        color: cs.onSurface,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),

              if (sourceType == AudioSourceType.quranSurah) ...[
                const SizedBox(height: 6),
                AudioSeekBar(onSeek: onSeek, showDurations: false),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
