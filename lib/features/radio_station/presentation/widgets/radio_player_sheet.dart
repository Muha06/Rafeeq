import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/widgets/seek_bar.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/core/widgets/my_chip.dart';
import 'package:rafeeq/features/radio_station/domain/entities/radio_station.dart';
import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
import 'package:rafeeq/features/radio_station/presentation/widgets/category_fallback_image.dart';

class RadioPlayerSheet extends ConsumerStatefulWidget {
  const RadioPlayerSheet({super.key, required this.station});

  final RadioStation station;

  @override
  ConsumerState<RadioPlayerSheet> createState() => _RadioPlayerSheetState();
}

class _RadioPlayerSheetState extends ConsumerState<RadioPlayerSheet> {
  Color? dominantColor;
  RadioStation get station => widget.station;

  @override
  void initState() {
    super.initState();
    _loadColor();
    _autoPlay();
  }

  //Load dominant color of the image
  Future<void> _loadColor() async {
    final url = widget.station.imageUrl;

    if (url == null || url.isEmpty) return;

    try {
      final palette = await PaletteGeneratorMaster.fromImageProvider(
        NetworkImage(url),
        size: const Size(200, 200), // helps performance + reliability
      );

      final color = palette.dominantColor?.color;

      debugPrint("Dominant color for ${widget.station.name}: $color");

      if (mounted) {
        setState(() {
          dominantColor = color;
        });
      }
    } catch (e) {
      debugPrint("Color extraction failed: $e");
    }
  }

  //Auto start Playing
  Future<void> _autoPlay() async {
    final state = ref.read(audioControllerProvider);
    final currentId = station.id;

    if (state.currentId == currentId && state.isPlaying) {
      return; // already playing this station
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _togglePlay();
    });
  }

  Future<void> _togglePlay() async {
    final id = station.id;
    final title = station.name;
    final url = station.streamUrl;

    try {
      await ref
          .read(audioControllerProvider.notifier)
          .togglePlay(context: context, currentId: id, url: url, title: title);
    } catch (e) {
      _showErrorSnack(
        'Failed to play audio. Please check your internet connection.',
      );
      debugPrint("Caught ERROR: $e");
      rethrow;
    }
  }

  void _showErrorSnack(String message) {
    if (!context.mounted) return;

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

    final state = ref.watch(audioControllerProvider);
    final isBuffering = state.isBuffering;
    final isPlaying = state.isPlaying;

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (dominantColor ?? cs.primary).withAlpha(25),
            cs.surface,
            cs.surface,
          ],
        ),
      ),
      child: Column(
        children: [
          // Minimize button
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(PhosphorIcons.caretDown(PhosphorIconsStyle.bold)),
              onPressed: () => AppNav.pop(context),
            ),
          ),

          const SizedBox(height: 20),

          //  large Image
          Center(
            child: station.imageUrl != null
                ? AppCachedImage(
                    imageUrl: station.imageUrl,
                    height: 350,
                    width: double.infinity,
                  )
                : CategoryFallback(
                    station: station,
                    height: 350,
                    width: double.infinity,
                  ),
          ),

          const SizedBox(height: 20),

          // Station name
          Text(
            station.name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: tt.headlineSmall!.copyWith(color: cs.onSurface),
          ),

          const SizedBox(height: 12),

          //Type of audio
          MyChip(
            child: Text(
              station.category.label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: tt.labelMedium!.copyWith(color: cs.onSurfaceVariant),
            ),
          ),

          const SizedBox(height: 20),

          // Audio controls
          // Seekbar
          const SizedBox(
            height: 48,
            child: _RadioAudioSeekBar(), // your seekbar
          ),

          const SizedBox(height: 20),

          // Play/pause
          AnimatedPlayPauseBtn(
            onPressed: _togglePlay,
            isPlaying: isPlaying,
            isBuffering: isBuffering,
          ),
        ],
      ),
    );
  }
}

class AnimatedPlayPauseBtn extends StatelessWidget {
  const AnimatedPlayPauseBtn({
    super.key,
    required this.onPressed,
    required this.isPlaying,
    required this.isBuffering,
    this.duration = const Duration(milliseconds: 300),
    this.size = 48,
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
    final iconColor = color ?? Theme.of(context).colorScheme.onSurface;

    return IconButton(
      onPressed: onPressed,
      iconSize: size,
      color: iconColor,
      icon: AnimatedSwitcher(
        duration: duration,
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: isBuffering
            ? const CupertinoActivityIndicator()
            : isPlaying
            ? PhosphorIcon(
                key: const ValueKey('pause'),
                PhosphorIcons.pause(PhosphorIconsStyle.light),
              )
            : PhosphorIcon(
                key: const ValueKey('play'),
                PhosphorIcons.play(PhosphorIconsStyle.light),
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
