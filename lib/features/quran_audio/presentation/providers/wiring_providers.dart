import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/wiring_providers.dart';
import 'package:rafeeq/features/quran_audio/data/datasources/quran_audio_remote_ds.dart';
import 'package:rafeeq/features/quran_audio/data/repos/quran_audio_repo_impl.dart';
import 'package:rafeeq/features/quran_audio/domain/repos/quran_audio_repo.dart';
import 'package:rafeeq/features/quran_audio/domain/usecases/get_surah_audio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/core/constants/hive_boxes.dart';
import 'package:rafeeq/features/quran_audio/data/datasources/reciter_playlist_tracks_local_ds.dart';
import 'package:rafeeq/features/quran_audio/data/models/hive/reciter_playlist_tracks_hive.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
    ),
  );
});

final quranAudioApiServiceProvider = Provider<QuranAudioApiService>((ref) {
  final dio = ref.read(dioProvider);
  final auth = ref.read(quranAuthClientProvider);

  return QuranAudioApiService(clientId: quranClientId, auth: auth, dio: dio);
});

final quranAudioRepositoryProvider = Provider<QuranAudioRepository>((ref) {
  final remote = ref.read(quranAudioApiServiceProvider);
  final local = ref.read(reciterPlaylistLocalDataSourceProvider);
  final quranLocalDs = ref.read(quranLocalDsProvider);

  return QuranAudioRepositoryImpl(
    remote: remote,
    local: local,
    quranLocalDs: quranLocalDs,
  );
});

final getSurahAudioTrackUseCaseProvider = Provider<GetSurahAudioTrack>((ref) {
  final repo = ref.read(quranAudioRepositoryProvider);
  return GetSurahAudioTrack(repo);
});

final reciterPlaylistTracksBoxProvider =
    Provider<Box<ReciterPlaylistTracksHive>>((ref) {
      return Hive.box<ReciterPlaylistTracksHive>(
        HiveBoxes.reciterPlaylistTracks,
      );
    });

final reciterPlaylistLocalDataSourceProvider =
    Provider<ReciterPlaylistLocalDataSource>((ref) {
      return ReciterPlaylistLocalDataSource(
        box: ref.watch(reciterPlaylistTracksBoxProvider),
      );
    });
