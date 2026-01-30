import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod/legacy.dart';

final adhkarPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

final adhkarPlayingProvider = StreamProvider<bool>((ref) {
  final player = ref.watch(adhkarPlayerProvider);
  return player.playingStream;
});

final adhkarPositionProvider = StreamProvider<Duration>((ref) {
  final player = ref.watch(adhkarPlayerProvider);
  return player.positionStream;
});

final adhkarDurationProvider = StreamProvider<Duration?>((ref) {
  final player = ref.watch(adhkarPlayerProvider);
  return player.durationStream;
});

final activeAdhkarAssetProvider = StateProvider<String?>((ref) => null);
