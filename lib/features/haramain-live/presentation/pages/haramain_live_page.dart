import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class HaramainLivePage extends StatefulWidget {
  const HaramainLivePage({
    super.key,
    required this.title,
    required this.liveUrl,
  });

  final String title;
  final String liveUrl;

  @override
  State<HaramainLivePage> createState() => _HaramainLivePageState();
}

class _HaramainLivePageState extends State<HaramainLivePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.liveUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // autoplay
        _controller.setLooping(false); // live stream = no loop needed
      });
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    _controller.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
