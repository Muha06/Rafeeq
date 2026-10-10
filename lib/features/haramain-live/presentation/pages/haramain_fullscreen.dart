import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class HaramainFullscreenPage extends StatefulWidget {
  const HaramainFullscreenPage({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  State<HaramainFullscreenPage> createState() => _HaramainFullscreenPageState();
}

class _HaramainFullscreenPageState extends State<HaramainFullscreenPage> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    _enterFullscreen();
  }

  Future<void> _enterFullscreen() async {
    await Future.delayed(500.ms);

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _exitFullscreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    if (mounted) {
      AppNav.pop(context);
    }
  }

  @override
  void dispose() { 
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: SafeArea(
                child: IconButton.filledTonal(
                  onPressed: _exitFullscreen,
                  tooltip: 'Exit fullscreen',
                  icon: const Icon(Icons.fullscreen_exit),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
