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
  // late Color? _dominantColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final audioState = ref.watch(audioControllerProvider);
    final ctrl = ref.read(audioControllerProvider.notifier);

    final isPlaying = audioState.isPlaying;
    final isBuffering = audioState.isBuffering;
    final position = audioState.position;
    final buffered = audioState.bufferedPosition;
    final duration = audioState.duration;
    final onSeek = ctrl.seek;

    final session = ref.watch(radioPlaybackSessionProvider);

    final controlsIconSize = 24.0;

    return SafeArea(
      top: false,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          switch (audioState.sourceType) {
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
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: cs.surfaceContainerHighest,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (audioState.imageUrl != null) ...[
                    AppCachedImage(
                      imageUrl: audioState.imageUrl,
                      height: 48,
                      width: 48,
                      borderRadius: 12,
                    ),
                    const SizedBox(width: 12),
                  ],

                  // Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextScroll(
                          audioState.title ?? 'Now playing',
                          style: theme.textTheme.labelLarge,
                        ),

                        // Artist
                        if (audioState.artist != null)
                          SizedBox(
                            width: double.infinity,
                            child: TextScroll(
                              "🎧 ${audioState.artist!}",
                              mode: TextScrollMode.endless,
                              velocity: const Velocity(
                                pixelsPerSecond: Offset(20, 0),
                              ),
                              textAlign: TextAlign.left,
                              style: theme.textTheme.labelMedium,
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
                      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                    },
                    icon: Icon(
                      HugeIconsStroke.cancel01,
                      size: controlsIconSize,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),

              const SizedBox(height: 6),

              if (audioState.sourceType == AudioSourceType.quranSurah)
                AudioSeekBar(
                  position: position,
                  buffered: buffered,
                  duration: duration,
                  onSeek: onSeek,
                  showDurations: false,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
