import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_tempt/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran_audio/data/datasources/quran_audio_remote_ds.dart';
import 'package:rafeeq/features/quran_audio/data/repos/quran_audio_repo_impl.dart';
import 'package:rafeeq/features/quran_audio/domain/repos/quran_audio_repo.dart';
import 'package:rafeeq/features/quran_audio/domain/usecases/get_surah_audio.dart';

final quranAudioApiServiceProvider = Provider<QuranAudioApiService>((ref) {
  final client = ref.read(httpClientProvider);
  final auth = ref.read(quranAuthClientProvider);

  return QuranAudioApiService(
    clientId: quranClientId,
    auth: auth,
    client: client,
  );
});

final quranAudioRepositoryProvider = Provider<QuranAudioRepository>((ref) {
  final api = ref.read(quranAudioApiServiceProvider);
  return QuranAudioRepositoryImpl(api: api);
});

final getSurahAudioTrackProvider = Provider<GetSurahAudioTrack>((ref) {
  final repo = ref.read(quranAudioRepositoryProvider);
  return GetSurahAudioTrack(repo);
});
