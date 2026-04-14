import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/audio/data/audio_handler.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_state.dart';
import 'package:rafeeq/core/features/audio/providers/audio_handler_provider.dart';
import 'package:rafeeq/core/helpers/audio_helpers.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';

/// This is the single source of truth for audio UI state.
///
/// Responsibilities:
/// - Handle UI actions (play, pause, seek, repeat)
/// - Sync state from AudioHandler
///
/// DO NOT:
/// - touch AudioPlayer directly
class AudioController extends Notifier<AudioState> {
  late final AppAudioHandler _handler;
  static const _notificationPrefix = 'Rafeeq - ';

  @override
  AudioState build() {
    _handler = ref.read(audioHandlerProvider);
    _listenToHandler();
    return const AudioState();
  }

  /// Loads a new audio track and starts playback.
  Future<void> loadAndPlay({
    required String currentId,
    required String url,
    String? artist,
    required String title,
  }) async {
    try {
      state = state.copyWith(
        currentId: currentId,
        title: title,
        isBuffering: true,
      );

      debugPrint('Loading audio: $currentId');

      await _handler.load(
        currentId: currentId,
        title: title,
        artist: artist,
        url: AudioHelpers.secureUrl(url),
      );

      await _handler.setSingleTrackLoop(state.isRepeatEnabled);
    } catch (e, st) {
      debugPrint('Audio load failed: $e');
      debugPrint('$st');
      state = state.copyWith(isBuffering: false);
      rethrow;
    }
  }

  Future<void> play() async {
    try {
      await _handler.play();
    } catch (e) {
      debugPrint('Play failed: $e');
      rethrow;
    }
  }

  Future<void> pause() async {
    try {
      await _handler.pause();
    } catch (e) {
      debugPrint('Pause failed: $e');
      rethrow;
    }
  }

  Future<void> stop() async {
    try {
      await _handler.stop();
      state = const AudioState();
    } catch (e) {
      debugPrint('Stop failed: $e');
      rethrow;
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _handler.seek(position);
    } catch (e) {
      debugPrint('Seek failed: $e');
    }
  }

  Future<void> setRepeatMode(bool enabled) async {
    try {
      await _handler.setSingleTrackLoop(enabled);
      state = state.copyWith(isRepeatEnabled: enabled);
    } catch (e) {
      debugPrint('Repeat mode update failed: $e');
    }
  }

  Future<void> toggleRepeatMode() async {
    await setRepeatMode(!state.isRepeatEnabled);
  }

  void _listenToHandler() {
    _handler.playbackState.listen(
      (playbackState) {
        final isPlaying = playbackState.playing;
        final isBuffering =
            playbackState.processingState == AudioProcessingState.loading ||
            playbackState.processingState == AudioProcessingState.buffering;

        state = state.copyWith(
          isPlaying: isPlaying,
          isBuffering: isBuffering,
          bufferedPosition: playbackState.bufferedPosition,
          position: playbackState.updatePosition,
        );
      },
      onError: (error, stack) {
        debugPrint('Playback stream error: $error');
        debugPrint('$stack');
      },
    );

    // Listen to media item updates (e.g. title, duration)
    _handler.mediaItem.listen((item) {
      if (item == null) return;

      //update title and duration
      //when media item changes (e.g. new track loaded)
      state = state.copyWith(
        title: _stripNotificationPrefix(item.title),
        duration: item.duration ?? Duration.zero,
      );
    });
  }

  //remove "Rafeeq - " prefix from notification title for in-app display
  String _stripNotificationPrefix(String title) {
    if (title.startsWith(_notificationPrefix)) {
      return title.substring(_notificationPrefix.length);
    }
    return title;
  }

  /// Smart play/pause handler:
  /// - New track -> load & play
  /// - Same track -> toggle play/pause
  Future<void> togglePlay({
    required BuildContext context,
    bool showAudioPlayer = true,
    required String currentId,
    String? artist,
    required String url,
    required String title,
  }) async {
    try {
      debugPrint('togglePlay called: $currentId, $url');

      final isNewTrack =
          state.currentId == null || state.currentId != currentId;

      if (isNewTrack) {
        debugPrint('Switching to new track: $currentId');

        await loadAndPlay(
          currentId: currentId,
          artist: artist,
          url: url,
          title: title,
        );

        if (showAudioPlayer) {
          AppSnackBar.showPlayer();
        }

        return;
      }

      if (state.isPlaying) {
        debugPrint('Pausing track');
        await pause();
      } else {
        debugPrint('Resuming track');
        await play();
      }
    } catch (e, st) {
      debugPrint('togglePlay failed: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}

final audioControllerProvider = NotifierProvider<AudioController, AudioState>(
  AudioController.new,
);
