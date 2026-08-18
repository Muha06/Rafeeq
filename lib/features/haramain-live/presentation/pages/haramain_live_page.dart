import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rafeeq/core/constants/spacing/app_spacing.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class HaramainLivePage extends StatefulWidget {
  const HaramainLivePage({super.key});

  @override
  State<HaramainLivePage> createState() => _HaramainLivePageState();
}

class _HaramainLivePageState extends State<HaramainLivePage> {
  VideoPlayerController? _controller;

  int _selectedIndex = 0;

  String? _error;
  bool isLoading = true;
  String _currentUrl = makkahLive;
  int _retryCount = 0;
  bool _isRetrying = false;
  static const makkahLive = 'https://win.holol.com/live/quran/playlist.m3u8';
  static const madinahLive = 'https://win.holol.com/live/sunnah/playlist.m3u8';

  @override
  void initState() {
    super.initState();

    _initController(_currentUrl);

    WakelockPlus.enable();
  }

  Future<void> _initController(String url) async {
    setState(() {
      isLoading = true;
      _error = null;
    });

    try {
      final newController = VideoPlayerController.networkUrl(Uri.parse(url));

      await newController.initialize();

      if (!mounted || url != _currentUrl) {
        await newController.dispose();
        return;
      }

      // Dispose old controller safely
      if (_controller != null) {
        await _controller!.dispose();
      }

      // Always attach listener to NEW controller
      final controller = newController;

      controller.addListener(() {
        final error = controller.value.errorDescription;

        if (error != null && error.isNotEmpty) {
          if (_error == null) {
            setState(() {
              _error = "Stream interrupted...";
              isLoading = false;
            });

            _autoReconnect(_currentUrl);
          }
        }
      });

      _controller = controller;

      await _controller?.play();

      setState(() {
        isLoading = false;
        _error = null;
        _retryCount = 0;
        _isRetrying = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = "Stream dropped. Reconnecting...";
        isLoading = false;
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

    if (!mounted || url != _currentUrl) {
      _isRetrying = false; // 🔥 MUST reset here
      return;
    }

    _retryCount++;

    await _initController(url);

    _isRetrying = false; // 🔥 always reset after attempt
  }

  Future<void> _switchStream(int index, String url) async {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
      _currentUrl = url;
    });

    await _initController(url);
  }

  @override
  void dispose() {
    _controller?.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  Widget _buildError() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.wifi_off, size: 40),
        const SizedBox(height: 10),
        Text(_error!, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => _initController(_currentUrl),
          child: const Text('Retry'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final isMakkah = _selectedIndex == 0;
    final isMadinah = !isMakkah;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              ChoiceChip(
                label: Text(
                  'Makkah',
                  style: theme.chipTheme.labelStyle?.copyWith(
                    color: isMakkah ? cs.onPrimary : cs.onSurfaceVariant,
                  ),
                ),
                selected: isMakkah,
                backgroundColor: _selectedIndex == 0 ? cs.primary : cs.surface,
                onSelected: (_) {
                  _switchStream(0, makkahLive);
                },
              ),

              const SizedBox(width: 8),

              ChoiceChip(
                label: Text(
                  'Madinah',
                  style: theme.chipTheme.labelStyle?.copyWith(
                    color: isMadinah ? cs.onPrimary : cs.onSurfaceVariant,
                  ),
                ),
                selected: isMadinah,
                backgroundColor: isMadinah ? cs.primary : cs.surface,
                onSelected: (_) {
                  _switchStream(1, madinahLive);
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xxxl),

        _error != null
            ? _buildError()
            : isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              )
            : (_controller != null && _controller!.value.isInitialized)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    ).animate().scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1.0, 1.0),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutBack,
                    ),
              )
            : const CircularProgressIndicator(),
      ],
    );
  }
}
