import 'package:flutter/material.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/haramain-live/presentation/pages/haramain_fullscreen.dart';
import 'package:video_player/video_player.dart';

class HaramainVideoPlayer extends StatefulWidget {
  const HaramainVideoPlayer({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  State<HaramainVideoPlayer> createState() => _HaramainVideoPlayerState();
}

class _HaramainVideoPlayerState extends State<HaramainVideoPlayer> {
  Future<void> _toggleFullscreen() async {
    AppNav.push(context, HaramainFullscreenPage(controller: widget.controller));
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton.filledTonal(
              onPressed: _toggleFullscreen,
              tooltip: 'Enter fullscreen',
              icon: const Icon(Icons.fullscreen),
            ),
          ),
        ],
      ),
    );
  }
}
