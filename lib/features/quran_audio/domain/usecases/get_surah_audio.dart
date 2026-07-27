import 'package:rafeeq/features/quran_audio/domain/entities/surah_track.dart';
import 'package:rafeeq/features/quran_audio/domain/entities/reciter_entity.dart';
import 'package:rafeeq/features/quran_audio/domain/repos/quran_audio_repo.dart';

class GetSurahAudioTrack {
  final QuranAudioRepository repo;

  const GetSurahAudioTrack(this.repo);

  Future<List<SurahTrack>> call({required ReciterEntity reciter}) {
    return repo.getSurahTracks(reciter: reciter);
  }
}
