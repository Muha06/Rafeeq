import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_item.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_source_type.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/presentation/widgets/seek_bar.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/core/widgets/my_chip.dart';
import 'package:rafeeq/features/quran_radio/domain/entities/radio_context.dart';
import 'package:rafeeq/features/quran_radio/domain/entities/radio_station.dart';
import 'package:rafeeq/features/quran_radio/domain/enums/radio_audio_category.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/radio_context_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/selected_station_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/widgets/category_fallback_image.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
import 'package:text_scroll/text_scroll.dart';

class RadioPlayerSheet extends ConsumerStatefulWidget {
  const RadioPlayerSheet({
    super.key,
    required this.stations,
    required this.initialIndex,
  });

  final List<RadioStation> stations;
  final int initialIndex;

  @override
  ConsumerState<RadioPlayerSheet> createState() => _RadioPlayerSheetState();
}

class _RadioPlayerSheetState extends ConsumerState<RadioPlayerSheet> {
  late int _currentIndex;

  RadioStation get station => widget.stations[_currentIndex];

  Color? _dominantColor;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    _loadPalette();

    // Delay autoplay until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoPlay();
    });
  }

  Future<void> _loadPalette() async {
    if (station.imageUrl == null || station.imageUrl!.isEmpty) return;

    try {
      final palette = await PaletteGeneratorMaster.fromImageProvider(
        NetworkImage(station.imageUrl!),
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

  //Auto start Playing
  Future<void> _autoPlay() async {
    final state = ref.read(audioControllerProvider);
    final currentId = station.id;
    ref.read(currentStationProvider.notifier).state = station;

    if (state.currentId == currentId && state.isPlaying) {
      return; // already playing this station
    }

    final playlist = widget.stations.map((station) {
      return AudioItem(
        id: station.id,
        title: 'Quran Radio',
        artist: station.name,
        imageUrl: station.imageUrl,
        sourceType: AudioSourceType.quranRadio,
        url: station.streamUrl,
      );
    }).toList();

    try {
      await ref
          .read(audioControllerProvider.notifier)
          .loadPlaylist(items: playlist, initialIndex: _currentIndex);

      ref
          .read(radioPlaybackSessionProvider.notifier)
          .state = RadioPlaybackSession(
        stations: widget.stations,
        currentIndex: _currentIndex,
      );
    } catch (e) {
      debugPrint("Error playing playlist $e");
    }
  }

  Future<void> _togglePlay() async {
    try {
      final items = widget.stations
          .map(
            (station) => AudioItem(
              id: station.id,
              title: 'Quran Radio',
              artist: station.name,
              sourceType: AudioSourceType.quranRadio,
              imageUrl: station.imageUrl,
              url: station.streamUrl,
            ),
          )
          .toList();

      final state = ref.read(audioControllerProvider);

      if (state.currentId == station.id) {
        if (state.isPlaying) {
          await ref.read(audioControllerProvider.notifier).pause();
        } else {
          await ref.read(audioControllerProvider.notifier).play();
        }
      } else {
        await ref
            .read(audioControllerProvider.notifier)
            .loadPlaylist(items: items, initialIndex: _currentIndex);
      }

      ref
          .read(radioPlaybackSessionProvider.notifier)
          .state = RadioPlaybackSession(
        stations: widget.stations,
        currentIndex: _currentIndex,
      );
    } catch (e) {
      _showErrorDialog(
        'Failed to play audio. Please check your internet connection.',
      );
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;

    AppSheets.showErrorDialog(
      context: context,
      title: 'Playback Error',
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final imageHeight = 280.0;
    final imageWidth = MediaQuery.of(context).size.width * 0.8;
    final dominant = _dominantColor ?? cs.primary;
    final tint = Color.lerp(cs.surface, dominant, .18)!;

    final station = widget.stations[_currentIndex];

    final showPrevIcon = _currentIndex > 0;
    final showNextIcon = _currentIndex < widget.stations.length - 1;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tint, tint.withValues(alpha: .55), cs.surface],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AppDragHandle(),

            const SizedBox(height: 80),

            // Image
            Center(
                  child: AppCachedImage(
                    imageUrl: station.imageUrl,
                    height: imageHeight,
                    width: imageWidth,
                    borderRadius: 48,
                    errorWidget: CategoryFallback(
                      station: station,
                      height: 300,
                      showShadow: false,
                      width: double.infinity,
                    ),
                  ),
                )
                .animate(key: ValueKey(station.id))
                .fade(duration: 600.ms)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(.94, .94),
                  curve: Curves.easeOutCubic,
                  duration: 600.ms,
                ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: TextScroll(
                "${station.name} ",
                mode: TextScrollMode.endless,
                velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                textAlign: TextAlign.center,
                style: tt.titleMedium?.copyWith(fontFamily: 'PlayFairDisplay'),
              ),
            ),

            const SizedBox(height: 8),

            //Type of audio
            MyChip(
              child: Text(
                station.category.label,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: tt.labelMedium!.copyWith(color: cs.onSurfaceVariant),
              ),
            ),

            const SizedBox(height: 32),

            // Seekbar
            const SizedBox(
              height: 52,
              child: _RadioAudioSeekBar(), // your seekbar
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: showPrevIcon
                      ? () => _goTo(_currentIndex - 1)
                      : null,
                  icon: Icon(
                    HugeIconsSolid.previous,
                    color: showPrevIcon ? cs.onSurface : cs.onSurfaceVariant,
                  ),
                ),

                // Play/pause
                Consumer(
                  builder: (_, context, _) {
                    final state = ref.watch(audioControllerProvider);
                    final isBuffering = state.isBuffering;

                    final isCurrent = state.currentId == station.id;
                    final isPlaying = isCurrent && state.isPlaying;

                    return AnimatedPlayPauseBtn(
                      onPressed: _togglePlay,
                      size: 36,
                      isPlaying: isPlaying,
                      isBuffering: isBuffering,
                    );
                  },
                ),

                IconButton(
                  onPressed: showNextIcon
                      ? () => _goTo(_currentIndex + 1)
                      : null,
                  icon: Icon(
                    HugeIconsSolid.next,
                    color: showNextIcon ? cs.onSurface : cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goTo(int newIndex) async {
    if (newIndex < 0 || newIndex >= widget.stations.length) return;

    setState(() {
      _currentIndex = newIndex;
    });

    ref.read(currentStationProvider.notifier).state = widget.stations[newIndex];

    ref.read(radioPlaybackSessionProvider.notifier).state =
        RadioPlaybackSession(stations: widget.stations, currentIndex: newIndex);

    await ref.read(audioControllerProvider.notifier).skipToIndex(newIndex);

    await _loadPalette();
  }
}

class AnimatedPlayPauseBtn extends StatelessWidget {
  const AnimatedPlayPauseBtn({
    super.key,
    required this.onPressed,
    required this.isPlaying,
    required this.isBuffering,
    this.duration = const Duration(milliseconds: 300),
    this.size = 40,
    this.color,
  });

  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onPressed;
  final Duration duration;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const double controlSize = 48;
    const double loaderRadius = controlSize / 2;

    final iconColor = color ?? cs.onPrimary;

    return GestureDetector(
      onTap: isBuffering ? null : onPressed,
      child: Material(
        shape: const CircleBorder(),
        color: cs.onSurface,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: AnimatedSwitcher(
              duration: duration,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: isBuffering
                  ? CupertinoActivityIndicator(
                      color: iconColor,
                      radius: loaderRadius,
                    )
                  : isPlaying
                  ? PhosphorIcon(
                      key: const ValueKey('pause'),
                      Icons.pause_rounded,
                      color: iconColor,
                      size: controlSize,
                    )
                  : PhosphorIcon(
                      key: const ValueKey('play'),
                      PhosphorIcons.playFill,
                      color: iconColor,
                      size: controlSize,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioAudioSeekBar extends ConsumerWidget {
  const _RadioAudioSeekBar();

  @override
  Widget build(BuildContext context, ref) {
    final audioState = ref.watch(audioControllerProvider);
    final ctrl = ref.watch(audioControllerProvider.notifier);

    final position = audioState.position;
    final buffered = audioState.bufferedPosition;
    final duration = audioState.duration;
    final onSeek = ctrl.seek;

    return AudioSeekBar(
      position: position,
      buffered: buffered,
      duration: duration,
      onSeek: onSeek,
    );
  }
}
