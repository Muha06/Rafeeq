import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class HaramainLivePage extends StatefulWidget {
  const HaramainLivePage({super.key});

  @override
  State<HaramainLivePage> createState() => _HaramainLivePageState();
}

class _HaramainLivePageState extends State<HaramainLivePage>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late TabController _tabController;

  static const makkahLive = 'https://win.holol.com/live/quran/playlist.m3u8';
  static const madinahLive = 'https://win.holol.com/live/sunnah/playlist.m3u8';

  String _currentUrl = makkahLive;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _controller = VideoPlayerController.networkUrl(Uri.parse(_currentUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(false);
      });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      final newUrl = _tabController.index == 0 ? makkahLive : madinahLive;

      if (newUrl == _currentUrl) return;

      _currentUrl = newUrl;

      _controller.dispose();

      _controller = VideoPlayerController.networkUrl(Uri.parse(_currentUrl))
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
        });
    });

    WakelockPlus.enable();
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haramain Live'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Makkah'),
            Tab(text: 'Madinah'),
          ],
        ),
      ),
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
