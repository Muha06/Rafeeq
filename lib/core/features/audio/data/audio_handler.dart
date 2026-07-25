import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_item.dart';
import 'package:rafeeq/core/helpers/audio_helpers.dart';

class AppAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer(); // engine
  List<AudioItem> playlist = [];

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
            MediaControl.skipToPrevious,
            if (playerState.playing) MediaControl.pause else MediaControl.play,
            MediaControl.skipToNext,
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

    _player.currentIndexStream.listen((index) {
      if (index == null) return;

      if (index < 0 || index >= playlist.length) return;
      final item = playlist[index];

      _setMediaItem(item: item, duration: _player.duration);
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
  Future<void> load({required AudioItem item}) async {
    try {
      // load audio
      final duration = await _player.setUrl(AudioHelpers.secureUrl(item.url));

      // Set media item for notification & controls
      _setMediaItem(item: item, duration: duration);
      playlist = [item];

      queue.add([
        MediaItem(
          id: item.id,
          title: 'Rafeeq - ${item.title}',
          artist: item.artist,
          duration: duration,
          playable: true,
        ),
      ]);

      await _player.play();
    } catch (e) {
      debugPrint('❌ Audio load failed: $e');
      rethrow;
    }
  }

  Future<void> loadPlaylist({
    required List<AudioItem> items,
    required int initialIndex,
  }) async {
    playlist = items;

    await _player.setAudioSources(
      items.map((item) {
        return AudioSource.uri(
          Uri.parse(AudioHelpers.secureUrl(item.url)),
          tag: item,
        );
      }).toList(),
      initialIndex: initialIndex,
    );

    queue.add(
      items
          .map(
            (item) => MediaItem(
              id: item.id,
              title: 'Rafeeq - ${item.title}',
              artist: item.artist,
              playable: true,
            ),
          )
          .toList(),
    );
    await _player.play();
  }

  //Helper to set media item for notification & controls
  void _setMediaItem({required AudioItem item, Duration? duration}) {
    mediaItem.add(
      MediaItem(
        id: item.id,
        title: 'Rafeeq - ${item.title}',
        duration: duration,
        artUri: item.imageUrl == null ? null : Uri.parse(item.imageUrl!),
        artist: item.artist,
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

  Future<void> setSingleTrackLoop(bool enabled) async {
    await _player.setLoopMode(enabled ? LoopMode.one : LoopMode.off);
  }

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> skipToQueueItem(int index) async {
    await _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> stop() async {
    await _player.setLoopMode(LoopMode.off);
    await _player.stop();
  }
}
