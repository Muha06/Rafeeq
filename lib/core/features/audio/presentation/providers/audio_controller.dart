import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/audio/data/audio_handler.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_item.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_state.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_handler_provider.dart';

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

  late final StreamSubscription _playbackSub;
  late final StreamSubscription _mediaSub;

  @override
  AudioState build() {
    _handler = ref.read(audioHandlerProvider);
    _listenToHandler();

    ref.onDispose(() {
      _playbackSub.cancel();
      _mediaSub.cancel();
    });

    return const AudioState();
  }

  /// Loads a new audio track and starts playback.
  Future<void> loadAndPlay({required AudioItem item}) async {
    final oldState = state;
    try {
      // Update state

      state = state.copyWith(
        currentId: item.id,
        title: item.title,
        artist: item.artist,
        sourceType: item.sourceType,
        imageUrl: item.imageUrl,
        isBuffering: true,
      );

      debugPrint('Loading audio: ${item.id}');

      await _handler.load(item: item);

      await _handler.setSingleTrackLoop(state.isRepeatEnabled);
    } catch (e, st) {
      debugPrint('Audio load failed: $e');
      debugPrint('$st');
      state = oldState;
      rethrow;
    }
  }

  Future<void> loadPlaylist({
    required List<AudioItem> items,
    required int initialIndex,
  }) async {
    final oldState = state;
    try {
      final current = items[initialIndex];

      state = state.copyWith(
        currentId: current.id,
        title: current.title,
        imageUrl: current.imageUrl,
        sourceType: current.sourceType,
        artist: current.artist,
        isBuffering: true,
      );

      await _handler.loadPlaylist(items: items, initialIndex: initialIndex);

      await _handler.setSingleTrackLoop(state.isRepeatEnabled);
    } catch (e) {
      state = oldState;
      rethrow;
    }
  }

  Future<void> next() async {
    await _handler.skipToNext();
  }

  Future<void> previous() async {
    await _handler.skipToPrevious();
  }

  Future<void> skipToIndex(int index) async {
    await _handler.skipToQueueItem(index);
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
      state = state.copyWith(isSeekingAudio: true);
    try {
      await _handler.seek(position);
    } catch (e) {
      debugPrint('Seek failed: $e');
    } finally {
      state = state.copyWith(isSeekingAudio: false);
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
    // Listen to handler
    _playbackSub = _handler.playbackState.listen(
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
    _mediaSub = _handler.mediaItem.listen((item) {
      if (item == null) return;

      // Update track metadata when media item changes (e.g. new track loaded).
      state = state.copyWith(
        currentId: item.id,
        title: _stripNotificationPrefix(item.title),
        artist: item.artist,
        imageUrl: item.artUri?.toString(),
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
  Future<void> togglePlay({required AudioItem item}) async {
    try {
      debugPrint(
        'togglePlay called: ${item.id}, ${item.url}, image: ${item.imageUrl}',
      );

      final isNewTrack = state.currentId == null || state.currentId != item.id;

      if (isNewTrack) {
        debugPrint(
          'Switching to new track: ${item.id} has image: ${item.imageUrl != null}',
        );

        await loadAndPlay(item: item);

        return;
      }

      if (state.isPlaying) {
        debugPrint('Pausing track');
        await pause();
      } else {
        debugPrint('Resuming track');
        await play();
      }
    } catch (e) {
      debugPrint('togglePlay failed: $e');
      rethrow;
    }
  }

  Future skipForward10() async {
    final newPosition = state.position + const Duration(seconds: 10);

    final duration = state.duration;
    if (newPosition > duration) {
      await seek(duration);
    } else {
      await seek(newPosition);
    }
  }

  Future skipBackward10() async {
    final newPosition = state.position - const Duration(seconds: 10);

    if (newPosition.isNegative) {
      await seek(Duration.zero);
    } else {
      await seek(newPosition);
    }
  }
}

final audioControllerProvider = NotifierProvider<AudioController, AudioState>(
  AudioController.new,
);
