import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_state.dart';
import 'package:rafeeq/core/features/audio/providers/just_audio_player_provider.dart';
import 'package:rafeeq/core/widgets/snackbars.dart';

final audioControllerProvider = NotifierProvider<AudioController, AudioState>(
  AudioController.new,
);

class AudioController extends Notifier<AudioState> {
  late final AudioPlayer _player;

  @override
  AudioState build() {
    _player = ref.read(justAudioPlayerProvider);
    return AudioState.empty;
  }

  //play URL
  Future<void> playUrl({
    required String url,
    required AudioSourceType source,
    required String id,
    required String title,
  }) async {
    // Same track? If paused, just resume.
    if (state.url == url && !_player.playing) {
      await _player.play();
      return;
    }

    //interrupt anything currently playing
    await _player.stop();

    state = state.copyWith(source: source, id: id, title: title, url: url);

    await _player.setUrl(url);
    AppSnackBar.showPlayer();
    await _player.play();
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();

  Future<void> stop() async {
    AppSnackBar.hideSnackbars();
    await _player.stop();
    state = AudioState.empty;
  }

  Future<void> seek(Duration pos) => _player.seek(pos);
}
