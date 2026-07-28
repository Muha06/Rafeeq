import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
import 'package:rafeeq/core/app_keys.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_source_type.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/presentation/widgets/seek_bar.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/log_ayah_bottomsheet.dart';
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
  late Color? _dominantColor;

  @override
  void initState() {
    super.initState();

    _loadPalette();
  }

  Future<void> _loadPalette() async {
    final state = ref.read(audioControllerProvider);

    if (state.imageUrl == null || state.imageUrl!.isEmpty) return;

    try {
      final palette = await PaletteGeneratorMaster.fromImageProvider(
        NetworkImage(state.imageUrl!),
        maximumColorCount: 12,
        generateHarmony: true,
        colorSpace: ColorSpace.lab,
      );

      if (!mounted) return;

      setState(() {
        _dominantColor = palette.dominantColor?.color;
      });
    } catch (e) {
      debugPrint('Palette error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(audioControllerProvider, (prev, next) {
      _loadPalette();
    });

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

    final base = cs.surfaceContainerHighest;
    final accent = _dominantColor ?? cs.primary;

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
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color.lerp(base, accent, 0.18)!),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(base, accent, 0.22)!,
                  Color.lerp(base, accent, 0.12)!,
                  base,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
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

                    isBuffering
                        ? const CupertinoActivityIndicator()
                        : CircleIconButton(
                            onPressed: isBuffering
                                ? null
                                : () => isPlaying ? ctrl.pause() : ctrl.play(),
                            icon: isPlaying
                                ? HugeIconsStroke.pause
                                : HugeIconsStroke.play,
                            size: 36,
                          ),

                    const SizedBox(width: 4),

                    //stop
                    CircleIconButton(
                      onPressed: () {
                        ref.read(currentStationProvider.notifier).state = null;

                        ref.read(radioPlaybackSessionProvider.notifier).state =
                            null;

                        ctrl.stop();
                        scaffoldMessengerKey.currentState
                            ?.hideCurrentSnackBar();
                      },
                      icon: HugeIconsStroke.cancel01,
                      size: 36,
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
      ),
    );
  }
}
