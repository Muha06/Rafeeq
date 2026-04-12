import 'package:equatable/equatable.dart';

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

  const AudioState({
    this.currentId,
    this.title,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.bufferedPosition = Duration.zero,
    this.isPlaying = false,
    this.isBuffering = false,
  });

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
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isBuffering,
    Duration? bufferedPosition,
  }) {
    return AudioState(
      currentId: currentId ?? this.currentId,
      title: title ?? this.title,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
    );
  }

  @override
  List<Object?> get props => [
    currentId,
    title,
    position,
    duration,
    isPlaying,
    isBuffering,
    bufferedPosition,
  ];
}
