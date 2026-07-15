import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/widgets/seek_bar.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_cache_image.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/core/widgets/my_chip.dart';
import 'package:rafeeq/features/radio_station/domain/entities/radio_station.dart';
import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';
import 'package:rafeeq/features/radio_station/presentation/widgets/category_fallback_image.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

class RadioPlayerSheet extends ConsumerStatefulWidget {
  const RadioPlayerSheet({super.key, required this.station});

  final RadioStation station;

  @override
  ConsumerState<RadioPlayerSheet> createState() => _RadioPlayerSheetState();
}

class _RadioPlayerSheetState extends ConsumerState<RadioPlayerSheet> {
  RadioStation get station => widget.station;
  Color? _dominantColor;

  @override
  void initState() {
    super.initState();
    _loadPalette();
    _autoPlay();
  }

  Future<void> _loadPalette() async {
    if (station.imageUrl == null || station.imageUrl!.isEmpty) return;

    try {
      final palette = await PaletteGeneratorMaster.fromImageProvider(
        NetworkImage(station.imageUrl!),
        maximumColorCount: 12,
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
      _showErrorDialog(
        'Failed to play audio. Please check your internet connection.',
      );
      debugPrint("Caught ERROR: $e");
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      height: MediaQuery.of(context).size.height * 1,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
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
            ),

            const SizedBox(height: 32),

            // Station name
            Text(
              station.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: tt.headlineSmall!.copyWith(
                color: cs.onSurface,
                fontFamily: 'PlayFairDisplay',
              ),
            ),

            const SizedBox(height: 16),

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
              height: 48,
              child: _RadioAudioSeekBar(), // your seekbar
            ),

            const SizedBox(height: 20),

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
          ],
        ),
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

    final iconColor = color ?? cs.onPrimary;

    return GestureDetector(
      onTap: isBuffering ? null : onPressed,
      child: Material(
        shape: const CircleBorder(),
        color: cs.onSurface,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                  ? CupertinoActivityIndicator(color: iconColor)
                  : isPlaying
                  ? PhosphorIcon(
                      key: const ValueKey('pause'),
                      Icons.pause_rounded,
                      color: iconColor,
                    )
                  : const PhosphorIcon(
                      key: ValueKey('play'),
                      PhosphorIcons.playFill,
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
