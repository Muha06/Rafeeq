import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_item.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_source_type.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/presentation/widgets/seek_bar.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/features/quran_radio/domain/entities/radio_context.dart';
import 'package:rafeeq/features/quran_radio/domain/entities/radio_station.dart';
import 'package:rafeeq/features/quran_radio/domain/enums/radio_audio_category.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/radio_context_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/radio_favs_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/selected_station_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/widgets/category_fallback_image.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:rafeeq/core/widgets/app_edge_fade.dart';

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

  // Auto start playing
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

      AppHaptics.light();
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final imageSize = (width - 48).clamp(0.0, 420.0).toDouble();

    final showPrevIcon = _currentIndex > 0;
    final showNextIcon = _currentIndex < widget.stations.length - 1;

    const itemColor = Colors.white;
    const disabledColor = Colors.white24;

    return SizedBox(
      height: double.infinity,
      child: Stack(
        children: [
          // Blurred artwork background
          if (station.imageUrl != null)
            Positioned.fill(
              child: ImageFiltered(
                key: ValueKey(station.imageUrl),
                imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child:
                    Image.network(
                          station.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        )
                        .animate(key: ValueKey(station.id))
                        .fadeIn(duration: 250.ms, curve: Curves.easeOut)
                        .scale(
                          begin: const Offset(0.7, 0.7),
                          end: const Offset(1, 1),
                          duration: 450.ms,
                          curve: Curves.easeOutCubic,
                        ),
              ),
            ),

          // Dark gradient overlay
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x99000000),
                    Color(0x99000000),
                    Color(0xE6000000),
                    Color(0xFF000000),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
              child: Column(
                children: [
                  _Header(onClose: () => Navigator.of(context).pop()),
                  const SizedBox(height: 24),

                  // Artwork
                  Center(
                    child: _Artwork(station: station, size: imageSize),
                  ),
                  const SizedBox(height: 32),

                  // Title + category
                  _TitleBlock(station: station),
                  const SizedBox(height: 20),

                  // Seekbar
                  const SizedBox(height: 52, child: _RadioAudioSeekBar()),
                  const SizedBox(height: 16),

                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: showPrevIcon
                            ? () {
                                _goTo(_currentIndex - 1);
                                AppHaptics.light();
                              }
                            : null,
                        icon: Icon(
                          HugeIconsSolid.previous,
                          size: 40,
                          color: showPrevIcon ? itemColor : disabledColor,
                        ),
                      ),
                      AnimatedPlayPauseBtn(
                        onPressed: _togglePlay,
                        size: 72,
                        bgColor: itemColor,
                        labelColor: Colors.black,
                      ),
                      IconButton(
                        onPressed: showNextIcon
                            ? () {
                                _goTo(_currentIndex + 1);
                                AppHaptics.light();
                              }
                            : null,
                        icon: Icon(
                          HugeIconsSolid.next,
                          size: 40,
                          color: showNextIcon ? itemColor : disabledColor,
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
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        IconButton(
          onPressed: onClose,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'PLAYING FROM',
                style: tt.labelSmall?.copyWith(
                  color: Colors.white60,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Quran Radio',
                style: tt.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 48), // balances the chevron
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Artwork
// ---------------------------------------------------------------------------

class _Artwork extends ConsumerWidget {
  const _Artwork({required this.station, required this.size});

  final RadioStation station;
  final double size;

  static const double _radius = 10;
  static const double _pausedScale = 0.86;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Buffering counts as active so skipping stations doesn't make the
    // artwork shrink and bounce back.
    final isActive = ref.watch(
      audioControllerProvider.select(
        (state) => state.isPlaying || state.isBuffering,
      ),
    );

    return AppCachedImage(
          imageUrl: station.imageUrl,
          height: size,
          width: size,
          borderRadius: _radius,
          errorWidget: CategoryFallback(
            station: station,
            showShadow: false,
            height: size,
            width: size,
          ),
          placeholder: SizedBox(height: size, width: size),
        )
        // Station change: scale in whenever the station changes.
        .animate(key: ValueKey(station.id))
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 400.ms,
          curve: Curves.easeOutBack,
        )
        // Play / pause: scale and shadow share one animation value.
        .animate(target: isActive ? 1 : 0)
        .custom(
          duration: 400.ms,
          curve: Curves.easeOutCubic,
          builder: (context, t, child) => Transform.scale(
            scale: lerpDouble(_pausedScale, 1, t)!,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_radius),
                boxShadow: [
                  BoxShadow(
                    color: Color.lerp(
                      const Color(0x1F000000),
                      const Color(0x73000000),
                      t,
                    )!,
                    blurRadius: lerpDouble(14, 44, t)!,
                    offset: Offset(0, lerpDouble(6, 22, t)!),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
  }
}

// ---------------------------------------------------------------------------
// Title + category
// ---------------------------------------------------------------------------
class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.station});

  final RadioStation station;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MarqueeText(
                text: station.name,
                style: tt.headlineSmall?.copyWith(
                  fontFamily: AppStrings.displayFont,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                station.category.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tt.titleSmall?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _FavoriteButton(stationId: station.id),
      ],
    );
  }
}

/// Only scrolls when the text doesn't fit.
class _MarqueeText extends StatelessWidget {
  const _MarqueeText({required this.text, required this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();

        final overflows = painter.width > constraints.maxWidth;
        painter.dispose();

        if (!overflows) {
          return Text(text, maxLines: 1, style: style);
        }

        return AppEdgeFade(
          fadeLength: 14,
          child: TextScroll(
            "$text ",
            mode: TextScrollMode.endless,
            intervalSpaces: 16,
            velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
            style: style,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Play / pause
// ---------------------------------------------------------------------------

class AnimatedPlayPauseBtn extends ConsumerWidget {
  const AnimatedPlayPauseBtn({
    super.key,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 250),
    this.size = 72, // diameter of the circle
    this.bgColor,
    this.labelColor,
  });

  final VoidCallback onPressed;
  final Duration duration;
  final double size;
  final Color? bgColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final iconColor = labelColor ?? cs.onPrimary;

    final isPlaying = ref.watch(
      audioControllerProvider.select((state) => state.isPlaying),
    );
    final isBuffering = ref.watch(
      audioControllerProvider.select((state) => state.isBuffering),
    );

    return Material(
      color: bgColor ?? cs.primary,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isBuffering ? null : onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: AnimatedSwitcher(
              duration: duration,
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: isBuffering
                  ? SizedBox(
                      key: const ValueKey('buffering'),
                      width: size * 0.4,
                      height: size * 0.4,
                      child: CircularProgressIndicator(
                        color: iconColor,
                        strokeWidth: 3,
                      ),
                    )
                  : Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      key: ValueKey(isPlaying),
                      color: iconColor,
                      size: size * 0.55,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioAudioSeekBar extends StatelessWidget {
  const _RadioAudioSeekBar();

  @override
  Widget build(BuildContext context) {
    return const AudioSeekBar(showDurations: false);
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.stationId});

  final String stationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isFavoriteStationProvider(stationId));

    return IconButton(
      onPressed: () {
        AppHaptics.light();
        ref.read(radioFavoritesProvider.notifier).toggle(stationId);
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: Icon(
          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(isFav),
          color: isFav ? Colors.redAccent : Colors.white70,
          size: 28,
        ),
      ),
    );
  }
}
