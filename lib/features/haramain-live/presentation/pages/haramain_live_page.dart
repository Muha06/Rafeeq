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

  String? _error;
  bool _isLoading = true;
  String _currentUrl = makkahLive;
  int _retryCount = 0;
  bool _isRetrying = false;
  bool _hasListener = false;
  static const makkahLive = 'https://win.holol.com/live/quran/playlist.m3u8';
  static const madinahLive = 'https://win.holol.com/live/sunnah/playlist.m3u8';

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      final newUrl = _tabController.index == 0 ? makkahLive : madinahLive;

      if (newUrl == _currentUrl) return;

      _currentUrl = newUrl;
      _initController(newUrl);
    });

    _initController(_currentUrl);

    WakelockPlus.enable();
  }

  Future<void> _initController(String url) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newController = VideoPlayerController.networkUrl(Uri.parse(url));

      await newController.initialize();

      if (!mounted) return;

      _controller.dispose();
      _controller = newController;

      if (!_hasListener) {
        _controller.addListener(() {
          final error = _controller.value.errorDescription;

          if (error != null && error.isNotEmpty) {
            if (_error == null) {
              setState(() {
                _error = "Stream interrupted...";
                _isLoading = false;
              });

              _autoReconnect(_currentUrl);
            }
          }
        });

        _hasListener = true;
      }

      await _controller.play();

      setState(() {
        _isLoading = false;
        _error = null;
        _retryCount = 0; // 🔥 reset on success
        _isRetrying = false;
      });
    } catch (e) {
      setState(() {
        _error = "Stream dropped. Reconnecting...";
        _isLoading = false;
      });

      debugPrint('Error $e');
      _autoReconnect(url);
    }
  }

  Future<void> _autoReconnect(String url) async {
    if (_isRetrying) return;

    _isRetrying = true;

    final delay = Duration(seconds: (_retryCount * 2).clamp(2, 10));

    await Future.delayed(delay);

    if (!mounted) return;

    _retryCount++;

    await _initController(url);

    _isRetrying = false;
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
        child: _error != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 40),
                  const SizedBox(height: 10),
                  Text(_error!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _initController(_currentUrl),
                    child: const Text("Retry"),
                  ),
                ],
              )
            : _isLoading
            ? const CircularProgressIndicator()
            : AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
      ),
    );
  }
}
