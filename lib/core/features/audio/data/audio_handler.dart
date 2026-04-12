import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rafeeq/core/helpers/audio_helpers.dart';

class AppAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer(); //real engine

  AppAudioHandler() {
    _init();
  }

  void _init() {
    // Listen to player state and update audio_service state accordingly
    _player.playerStateStream.listen((playerState) {
      playbackState.add(
        playbackState.value.copyWith(
          playing: playerState.playing,
          processingState: _mapState(playerState.processingState),
          controls: [
            if (playerState.playing) MediaControl.pause else MediaControl.play,
            MediaControl.stop,
          ],
          systemActions: const {MediaAction.seek},
        ),
      );
    });

    // Listen to position updates
    _player.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });

    //Listen to buffered position updates
    _player.bufferedPositionStream.listen((bufferedPosition) {
      playbackState.add(
        playbackState.value.copyWith(bufferedPosition: bufferedPosition),
      );
    });
  }

  // Helper: Map just_audio state → audio_service state
  AudioProcessingState _mapState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  /// Load + play
  Future<void> load({
    required String currentId,
    required String url,
    String? artist,
    required String title,
  }) async {
    try {
      // load audio
      final duration = await _player.setUrl(AudioHelpers.secureUrl(url));

      // Set media item for notification & controls
      _setMediaItem(
        id: currentId,
        duration: duration,
        artist: artist,
        title: title,
      );

      await _player.play();
    } catch (e) {
      debugPrint('❌ Audio load failed: $e');
      rethrow;
    }
  }

  //Helper to set media item for notification & controls
  void _setMediaItem({
    required String id,
    String? artist,
    Duration? duration,
    required String title,
  }) {
    mediaItem.add(
      MediaItem(
        id: id,
        title: title,
        duration: duration,
        artist: artist,
        // keeps notification stable
        playable: true,
      ), //this is will be displayed in the notification and controls
    );
  }

  //These methods are called by the Lock screen control playback.
  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();
}
