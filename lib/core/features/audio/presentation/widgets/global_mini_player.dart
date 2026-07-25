import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/app_keys.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_source_type.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/radio_context_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/selected_station_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/widgets/radio_player_sheet.dart';
import 'package:text_scroll/text_scroll.dart';

class GLobalMiniPlayerSheet extends ConsumerWidget {
  const GLobalMiniPlayerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final audioState = ref.watch(audioControllerProvider);
    final ctrl = ref.read(audioControllerProvider.notifier);

    final isPlaying = audioState.isPlaying;
    final isBuffering = audioState.isBuffering;
    final progress = audioState.duration.inMilliseconds == 0
        ? 0.0
        : audioState.position.inMilliseconds /
              audioState.duration.inMilliseconds;
    final session = ref.watch(radioPlaybackSessionProvider);
    debugPrint("Imageurl: ${audioState.imageUrl}");
    
    return SafeArea(
      top: false,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          debugPrint("Hello");
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
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: progress,
                color: cs.primary,
                minHeight: 2,
                backgroundColor: cs.primary,
              ),

              const SizedBox(height: 6),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppCachedImage(
                    imageUrl: audioState.imageUrl,
                    height: 48,
                    width: 48,
                    borderRadius: 12,
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextScroll(
                          audioState.title ?? 'Now playing',
                          style: theme.textTheme.labelLarge,
                        ),

                        // Artist
                        if (audioState.artist != null)
                          TextScroll(
                            audioState.artist!,
                            mode: TextScrollMode.endless,
                            velocity: const Velocity(
                              pixelsPerSecond: Offset(24, 0),
                            ),
                            textAlign: TextAlign.left,
                            style: theme.textTheme.labelMedium,
                          ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: isBuffering
                        ? null
                        : () => isPlaying ? ctrl.pause() : ctrl.play(),
                    icon: isBuffering
                        ? const CupertinoActivityIndicator()
                        : Icon(
                            isPlaying
                                ? HugeIconsSolid.pause
                                : HugeIconsSolid.play,
                          ),
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
                    icon: const Icon(HugeIconsSolid.cancel01),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
