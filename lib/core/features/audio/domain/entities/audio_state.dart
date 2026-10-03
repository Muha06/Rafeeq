import 'package:equatable/equatable.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_source_type.dart';

/// Represents the current state of the global audio player.
///
/// This is the SINGLE source of truth for:
/// - UI (play/pause button state)
/// - progress bar
/// - buffering indicator
/// - currently playing track info
class AudioState extends Equatable {
  //Id (For surah: surahId, ayah:surahid:ayahNumber, adhkar: dhikrId)
  final String? currentId;

  /// Title of current audio (e.g. Surah name)
  final String? title;

  /// Artist of current audio (e.g. Surah name)
  final String? artist;

  /// Imarge of current audio
  final String? imageUrl;

  /// audio source type of current audio (e.g. Quran radio)
  final AudioSourceType sourceType;

  /// Current playback position
  final Duration position;

  /// Total duration of audio
  final Duration duration;

  /// Whether audio is currently playing
  final bool isPlaying;

  /// Whether audio is buffering/loading
  final bool isBuffering;

  //Buffered position
  final Duration bufferedPosition;

  /// Whether the current track should restart after it completes.
  final bool isRepeatEnabled;

  final bool isSeekingAudio;

  const AudioState({
    this.currentId,
    this.title,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.bufferedPosition = Duration.zero,
    this.isPlaying = false,
    this.isBuffering = false,
    this.isRepeatEnabled = false,
    this.artist,
    this.imageUrl,
    this.sourceType = AudioSourceType.other,
    this.isSeekingAudio = false,
  });

  static const _unset = Object();

  /// Progress from 0.0 → 1.0
  /// Used for progress bar UI
  double get progress {
    if (duration.inMilliseconds == 0) return 0.0;
    return position.inMilliseconds / duration.inMilliseconds;
  }

  /// Buffered progress from 0.0 → 1.0
  /// Used for progress bar UI
  double get bufferedProgress {
    if (duration.inMilliseconds == 0) return 0.0;
    return bufferedPosition.inMilliseconds / duration.inMilliseconds;
  }

  /// Creates a copy with updated values (immutable pattern)
  AudioState copyWith({
    String? currentId,
    String? title,
    Object? artist = _unset,
    Object? imageUrl = _unset,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isBuffering,
    Duration? bufferedPosition,
    bool? isRepeatEnabled,
    AudioSourceType? sourceType,
    bool? isSeekingAudio,
  }) {
    return AudioState(
      currentId: currentId ?? this.currentId,
      title: title ?? this.title,
      artist: identical(artist, _unset) ? this.artist : artist as String?,
      imageUrl: identical(imageUrl, _unset)
          ? this.imageUrl
          : imageUrl as String?,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
      isRepeatEnabled: isRepeatEnabled ?? this.isRepeatEnabled,
      sourceType: sourceType ?? this.sourceType,
      isSeekingAudio: isSeekingAudio ?? this.isSeekingAudio,
    );
  }

  @override
  List<Object?> get props => [
    currentId,
    title,
    artist,
    imageUrl,
    sourceType,
    position,
    duration,
    isPlaying,
    isBuffering,
    bufferedPosition,
    isRepeatEnabled,
    isSeekingAudio,
  ];
}
