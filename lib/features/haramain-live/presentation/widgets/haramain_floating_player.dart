import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HaramainFloatingPlayer extends StatelessWidget {
  const HaramainFloatingPlayer({
    super.key,
    required this.controller,
    required this.onClose,
    required this.onFullscreen,
  });

  final VideoPlayerController controller;
  final VoidCallback onClose;
  final VoidCallback onFullscreen;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      elevation: 8,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 220,
        height: 124,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: _PlayerButton(
                icon: Icons.close,
                tooltip: 'Close player',
                onPressed: onClose,
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: _PlayerButton(
                icon: Icons.fullscreen,
                tooltip: 'Fullscreen',
                onPressed: onFullscreen,
              ),
            ),
            const Positioned(
              bottom: 8,
              left: 8,
              child: IgnorePointer(
                child: Icon(
                  Icons.drag_indicator,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerButton extends StatelessWidget {
  const _PlayerButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        visualDensity: VisualDensity.compact,
        icon: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
