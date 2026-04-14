import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/widgets/seek_bar.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/core/widgets/my_chip.dart';
import 'package:rafeeq/features/radio_station/domain/entities/radio_station.dart';
import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

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
      try {
        await _togglePlay();
      } catch (e) {
        _showErrorSnack('Failed to play audio');
      }
    });
  }

  Future<void> _togglePlay() async {
    final id = station.id;
    final title = station.name;
    final url = station.streamUrl;

    await ref
        .read(audioControllerProvider.notifier)
        .togglePlay(context: context, currentId: id, url: url, title: title);
  }

  void _showErrorSnack(String message) {
    AppSnackBar.showSimple(context: context, message: message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    final isPlaying = ref.watch(audioControllerProvider).isPlaying;

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
            child: Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: IconButton(
                icon: Icon(PhosphorIcons.caretDown()),
                onPressed: () => AppNav.pop(context),
              ),
            ),
          ),

          const SizedBox(height: 20),

          //  large Image
          const Center(
            child: AppCachedImage(
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4iOQjZV-CanT2x-vkfs5xsNNDWEVPt2SHJw&s',
              //for now, later use station.imageUrl
              height: 350,
              width: 350,
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
          AnimatedPlayPauseBtn(onPressed: _togglePlay, isPlaying: isPlaying),
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
    this.duration = const Duration(milliseconds: 300),
    this.size = 48,
    this.color,
  });

  final bool isPlaying;
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
        child: isPlaying
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
