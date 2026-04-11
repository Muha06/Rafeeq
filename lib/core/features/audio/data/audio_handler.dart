import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rafeeq/core/helpers/audio_helpers.dart';

class AppAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  AppAudioHandler() {
    _init();
  }

  void _init() {
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

    _player.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });

    _player.bufferedPositionStream.listen((bufferedPosition) {
      playbackState.add(
        playbackState.value.copyWith(bufferedPosition: bufferedPosition),
      );
    });
  }

  // 🔄 Map just_audio → audio_service state
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
    required String title,
  }) async {
    try {
      // 🎧 load audio
      final duration = await _player.setUrl(AudioHelpers.secureUrl(url));

      _setMediaItem(id: currentId, duration: duration, title: title);

      await _player.play();
    } catch (e) {
      debugPrint('❌ Audio load failed: $e');
    }
  }

  void _setMediaItem({
    required String id,
    Duration? duration,
    required String title,
  }) {
    mediaItem.add(
      MediaItem(
        id: id,
        title: title,
        duration: duration,
        // optional but good for future
        artist: 'Rafeeq Recitation',

        // keeps notification stable
        playable: true,
      ),
    );
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();
}
