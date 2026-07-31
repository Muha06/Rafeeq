import 'dart:ui';

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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // Delay autoplay until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoPlay();
    });
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

    final station = widget.stations[_currentIndex];

    final showPrevIcon = _currentIndex > 0;
    final showNextIcon = _currentIndex < widget.stations.length - 1;

    final itemColor = Colors.white;

    return SizedBox(
      height: double.infinity,
      child: Stack(
        children: [
          if (station.imageUrl != null)
            Positioned.fill(
              child: ImageFiltered(
                key: ValueKey(station.imageUrl),
                imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Image.network(station.imageUrl!, fit: BoxFit.cover)
                    .animate()
                    .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                    .scale(
                      begin: const Offset(1.15, 1.15),
                      end: const Offset(1.0, 1.0),
                      duration: 500.ms,
                      curve: Curves.easeOutCubic,
                    ),
              ),
            ),

          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(color: Colors.black87),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  AppDragHandle(color: itemColor),

                  const SizedBox(height: 80),

                  // Image
                  Center(
                    child: AppCachedImage(
                      imageUrl: station.imageUrl,
                      height: imageHeight,
                      width: imageWidth,
                      borderRadius: 32,
                      errorWidget: CategoryFallback(
                        station: station,
                        showShadow: false,
                        height: 300,
                        width: double.infinity,
                      ),
                      placeholder: Container(
                        height: 300,
                        width: double.infinity,
                        color: Colors.transparent,
                      ),
                    ),
                  ).animate(key: ValueKey(station.id)).fade(duration: 300.ms),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: TextScroll(
                      "${station.name} ",
                      mode: TextScrollMode.endless,
                      intervalSpaces: 16,
                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                      textAlign: TextAlign.center,
                      style: tt.titleMedium?.copyWith(
                        fontFamily: 'PlayFairDisplay',
                        color: itemColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  //Type of audio
                  MyChip(
                    borderRadius: 6,
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    child: Text(
                      station.category.label,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: tt.labelMedium!.copyWith(color: itemColor),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: showPrevIcon
                            ? () => _goTo(_currentIndex - 1)
                            : null,
                        icon: Icon(
                          size: 36,
                          HugeIconsSolid.previous,
                          color: showPrevIcon ? itemColor : cs.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Play/pause
                      AnimatedPlayPauseBtn(
                        onPressed: _togglePlay,
                        size: 36,
                        bgColor: itemColor,
                        labelColor: Colors.black,
                      ),

                      const SizedBox(width: 24),

                      IconButton(
                        onPressed: showNextIcon
                            ? () => _goTo(_currentIndex + 1)
                            : null,
                        icon: Icon(
                          HugeIconsSolid.next,
                          size: 36,
                          color: showNextIcon ? itemColor : cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
  }
}

class AnimatedPlayPauseBtn extends ConsumerWidget {
  const AnimatedPlayPauseBtn({
    super.key,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 300),
    this.size = 40,
    this.bgColor,
    this.labelColor,
  });

  final VoidCallback onPressed;
  final Duration duration;
  final double size;
  final Color? bgColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const double controlSize = 40;

    final iconColor = labelColor ?? cs.onPrimary;

    final isPlaying = ref.watch(
      audioControllerProvider.select((state) => state.isPlaying),
    );
    final isBuffering = ref.watch(
      audioControllerProvider.select((state) => state.isBuffering),
    );
    return GestureDetector(
      onTap: isBuffering ? null : onPressed,
      child: Material(
        shape: const CircleBorder(),
        color: bgColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: isBuffering
                ? SizedBox(
                    height: controlSize,
                    width: controlSize,
                    child: CircularProgressIndicator(color: iconColor),
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
                    Icons.play_arrow,
                    color: iconColor,
                    size: controlSize,
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
    final ctrl = ref.read(audioControllerProvider.notifier);

    final onSeek = ctrl.seek;

    return AudioSeekBar(onSeek: onSeek, showDurations: false);
  }
}
