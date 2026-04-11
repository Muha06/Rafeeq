import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/audio/data/audio_handler.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_state.dart';
import 'package:rafeeq/core/features/audio/providers/audio_handler_provider.dart';
import 'package:rafeeq/core/helpers/audio_helpers.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';

/// 🎧 AudioController
///
/// This is the SINGLE source of truth for audio UI state.
///
/// Responsibilities:
/// - Handle UI actions (play, pause, seek)
/// - Sync state from AudioHandler
/// - Keep UI reactive and clean
///
/// DO NOT:
/// - touch AudioPlayer directly
/// - duplicate playback logic here
class AudioController extends Notifier<AudioState> {
  late final AppAudioHandler _handler;

  /// Called once when provider is first created.
  /// Sets up handler + listeners.
  @override
  AudioState build() {
    _handler = ref.read(audioHandlerProvider);

    _listenToHandler();

    return const AudioState();
  }

  //──────────────────────────────────────────────
  // 🎯 CORE ACTIONS
  //──────────────────────────────────────────────

  /// Loads a new audio track and starts playback.
  ///
  /// Used when:
  /// - first play
  /// - switching track
  Future<void> loadAndPlay({
    required String currentId,
    required String url,
    required String title,
  }) async {
    try {
      // Update UI immediately (optimistic state)
      state = state.copyWith(
        currentId: currentId,
        title: title,
        isBuffering: true,
      );

      debugPrint('🎧 Loading audio: $currentId');

      await _handler.load(
        currentId: currentId,
        url: AudioHelpers.secureUrl(url),
        title: title,
      );
    } catch (e, st) {
      // Fail safely without crashing UI
      debugPrint('❌ Failed to load audio: $e');
      debugPrint('$st');

      state = state.copyWith(isBuffering: false);
    }
  }

  /// Resume playback
  Future<void> play() async {
    try {
      await _handler.play();
    } catch (e) {
      debugPrint('❌ Play failed: $e');
    }
  }

  /// Pause playback
  Future<void> pause() async {
    try {
      await _handler.pause();
    } catch (e) {
      debugPrint('❌ Pause failed: $e');
    }
  }

  /// Stop playback and reset state
  Future<void> stop() async {
    try {
      await _handler.stop();
      state = const AudioState();
    } catch (e) {
      debugPrint('❌ Stop failed: $e');
    }
  }

  /// Seek to specific position in current track
  Future<void> seek(Duration position) async {
    try {
      await _handler.seek(position);
    } catch (e) {
      debugPrint('❌ Seek failed: $e');
    }
  }

  //──────────────────────────────────────────────
  // 🔁 SYNC FROM AUDIO HANDLER
  //──────────────────────────────────────────────

  /// Listens to system-level playback state
  /// and syncs it to UI state.
  ///
  /// IMPORTANT:
  /// - This is the ONLY stream source
  /// - Do NOT duplicate listeners elsewhere
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
          position: playbackState.updatePosition,
        );
      },
      onError: (error, stack) {
        // Prevent silent stream crashes
        debugPrint('❌ Playback stream error: $error');
        debugPrint('$stack');
      },
    );
  }

  //──────────────────────────────────────────────
  // 🎮 TOGGLE LOGIC (SMART CONTROL)
  //──────────────────────────────────────────────

  /// Smart play/pause handler:
  /// - New track → load & play
  /// - Same track → toggle play/pause
  Future<void> togglePlay({
    required BuildContext context,
    bool showAudioPlayer = true,
    required String currentId,
    required String url,
    required String title,
  }) async {
    try {
      final isNewTrack =
          state.currentId == null || state.currentId != currentId;

      // 🎯 Case 1: New track
      if (isNewTrack) {
        debugPrint('🎧 Switching to new track: $currentId');

        await loadAndPlay(currentId: currentId, url: url, title: title);

        // Optional UI feedback
        if (showAudioPlayer) {
          AppSnackBar.showPlayer();
        }

        return;
      }

      // 🎯 Case 2: Same track toggle
      if (state.isPlaying) {
        debugPrint('⏸ Pausing track');
        await pause();
      } else {
        debugPrint('▶️ Resuming track');
        await play();
      }
    } catch (e, st) {
      // Global safety net
      debugPrint('❌ togglePlay failed: $e');
      debugPrint('$st');
    }
  }
}

/// 🌍 Global provider
///
/// UI:
/// - watch → state updates
/// - read → actions (play/pause/seek)
final audioControllerProvider = NotifierProvider<AudioController, AudioState>(
  AudioController.new,
);
