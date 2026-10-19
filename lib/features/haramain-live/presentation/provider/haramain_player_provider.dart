import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_item.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_source_type.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class HaramainPlayerState {
  const HaramainPlayerState({
    this.controller,
    this.selectedIndex = 0,
    this.error,
    this.isLoading = true,
    this.isVisible = false,
    this.isHaramainTabActive = false,
  });

  final VideoPlayerController? controller;
  final int selectedIndex; // Makkah => 0, Madinah => 1
  final String? error;
  final bool isLoading;
  final bool isVisible;
  final bool isHaramainTabActive;

  String get currentUrl => selectedIndex == 0 ? makkahLive : madinahLive;

  static const makkahLive = 'https://win.holol.com/live/quran/playlist.m3u8';
  static const madinahLive = 'https://win.holol.com/live/sunnah/playlist.m3u8';

  HaramainPlayerState copyWith({
    VideoPlayerController? controller,
    bool clearController = false,
    int? selectedIndex,
    String? error,
    bool clearError = false,
    bool? isLoading,
    bool? isVisible,
    bool? isHaramainTabActive,
  }) {
    return HaramainPlayerState(
      controller: clearController ? null : controller ?? this.controller,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      error: clearError ? null : error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isVisible: isVisible ?? this.isVisible,
      isHaramainTabActive: isHaramainTabActive ?? this.isHaramainTabActive,
    );
  }
}

final haramainPlayerProvider =
    NotifierProvider<HaramainPlayerNotifier, HaramainPlayerState>(
      HaramainPlayerNotifier.new,
    );

class HaramainPlayerNotifier extends Notifier<HaramainPlayerState> {
  VideoPlayerController? _controller;
  bool _disposed = false;
  bool _isRetrying = false;
  bool _shouldPlay = false;
  int _retryCount = 0;
  int _requestId = 0;
  int _playbackGeneration = 0;

  @override
  HaramainPlayerState build() {
    ref.onDispose(() {
      _disposed = true;
      _shouldPlay = false;
      _requestId++;
      _controller?.dispose();
      WakelockPlus.disable();
    });

    return const HaramainPlayerState();
  }

  Future<void> start() async {
    if (_controller != null) return;

    if (!_shouldPlay) _playbackGeneration++;
    _shouldPlay = true;
    await WakelockPlus.enable();
    if (_disposed || !_shouldPlay) {
      await WakelockPlus.disable();
      return;
    }

    await _initController(state.currentUrl);

    // Android controls
    await _play();
  }

  Future<void> _play() async {
    final title = state.currentUrl.contains('quran')
        ? 'Makkah live'
        : 'Madinah live';

    final item = AudioItem(
      id: state.currentUrl,
      title: title,
      url: state.currentUrl,
      sourceType: AudioSourceType.haramainLive,
    );

    await ref.read(audioControllerProvider.notifier).togglePlay(item: item);
  }

  Future<void> _initController(String url) async {
    if (_disposed || !_shouldPlay) return;

    final requestId = ++_requestId;

    state = state.copyWith(isLoading: true, clearError: true);

    VideoPlayerController? newController;

    try {
      newController = VideoPlayerController.networkUrl(Uri.parse(url));

      await newController.initialize();

      if (_disposed || requestId != _requestId || url != state.currentUrl) {
        await newController.dispose();
        return;
      }

      final oldController = _controller;
      _controller = newController;

      newController.addListener(() {
        if (_disposed || requestId != _requestId) return;

        final error = newController!.value.errorDescription;

        if (error != null && error.isNotEmpty && state.error == null) {
          state = state.copyWith(
            error: 'Stream interrupted. Reconnecting...',
            isLoading: false,
          );

          _autoReconnect(url);
        }
      });

      state = state.copyWith(
        controller: newController,
        isLoading: false,
        clearError: true,
      );

      await newController.play();

      if (oldController != null) {
        await oldController.dispose();
      }

      _retryCount = 0;
    } catch (e) {
      if (newController != null && newController != _controller) {
        await newController.dispose();
      }

      if (_disposed || requestId != _requestId) return;

      debugPrint('Haramain stream error: $e');

      state = state.copyWith(
        error: 'Stream dropped. Reconnecting...',
        isLoading: false,
      );

      _autoReconnect(url);
    }
  }

  Future<void> _autoReconnect(String url) async {
    if (_isRetrying || _disposed || !_shouldPlay) return;

    _isRetrying = true;
    final playbackGeneration = _playbackGeneration;

    final delaySeconds = (_retryCount * 2).clamp(2, 10);
    await Future.delayed(Duration(seconds: delaySeconds));

    if (_disposed ||
        !_shouldPlay ||
        playbackGeneration != _playbackGeneration ||
        url != state.currentUrl) {
      if (playbackGeneration == _playbackGeneration) _isRetrying = false;
      return;
    }

    _retryCount++;
    await _initController(url);

    _isRetrying = false;
  }

  Future<void> switchStream(int index) async {
    if (state.selectedIndex == index) {
      if (_controller == null) await start();
      return;
    }

    if (!_shouldPlay) _playbackGeneration++;
    _shouldPlay = true;
    state = state.copyWith(
      selectedIndex: index,
      clearError: true,
      isLoading: true,
    );

    _retryCount = 0;
    _isRetrying = false;

    await _initController(state.currentUrl);

    await _play();
  }

  Future<void> retry() async {
    if (!_shouldPlay) _playbackGeneration++;
    _shouldPlay = true;
    _retryCount = 0;
    _isRetrying = false;
    await _initController(state.currentUrl);
  }

  Future<void> stop() async {
    _shouldPlay = false;
    _playbackGeneration++;
    _isRetrying = false;
    _retryCount = 0;
    _requestId++;

    final controller = _controller;
    _controller = null;
    state = state.copyWith(
      clearController: true,
      clearError: true,
      isLoading: false,
      isVisible: false,
    );

    await Future.wait([
      if (controller != null) controller.dispose(),
      WakelockPlus.disable(),
    ]);

    await ref.read(audioControllerProvider.notifier).stop();
  }

  void hidePlayer() {
    state = state.copyWith(isVisible: false);
  }

  void showPlayer() {
    state = state.copyWith(isVisible: true);
  }

  void setHaramainTabActive(bool isActive) {
    state = state.copyWith(isHaramainTabActive: isActive, isVisible: !isActive);
  }
}
