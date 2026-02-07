import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

final justAudioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

final audioBufferingProvider = StreamProvider<bool>((ref) {
  final player = ref.watch(justAudioPlayerProvider);
  return player.processingStateStream.map(
    (s) => s == ProcessingState.loading || s == ProcessingState.buffering,
  );
});

final audioPlayingProvider = StreamProvider<bool>((ref) {
  final player = ref.watch(justAudioPlayerProvider);
  return player.playingStream;
});
