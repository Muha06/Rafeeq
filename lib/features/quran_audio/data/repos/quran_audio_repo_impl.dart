import 'package:flutter/cupertino.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_local_ds.dart';
import 'package:rafeeq/features/quran_audio/data/datasources/quran_audio_remote_ds.dart';
import 'package:rafeeq/features/quran_audio/data/datasources/reciter_playlist_tracks_local_ds.dart';
import 'package:rafeeq/features/quran_audio/data/models/hive/reciter_playlist_tracks_hive.dart';
import 'package:rafeeq/features/quran_audio/domain/entities/surah_track.dart';
import 'package:rafeeq/features/quran_audio/domain/entities/reciter_entity.dart';
import 'package:rafeeq/features/quran_audio/domain/repos/quran_audio_repo.dart';

class QuranAudioRepositoryImpl implements QuranAudioRepository {
  final QuranAudioApiService remote;
  final ReciterPlaylistLocalDataSource local;
  final QuranLocalDataSource quranLocalDs;

  QuranAudioRepositoryImpl({
    required this.remote,
    required this.local,
    required this.quranLocalDs,
  });

  @override
  Future<List<SurahTrack>> getSurahTracks({
    required ReciterEntity reciter,
  }) async {
    final cachedPlaylist = await local.getPlaylistTracks(reciter.id);

    if (cachedPlaylist != null) {
      debugPrint('✅ Playlist cache hit!');
      return cachedPlaylist.tracks.map((track) => track.toEntity()).toList();
    }

    debugPrint('😭 Playlist cache miss: fetching...');

    final fetchedFiles = await remote.fetchReciterPlaylist(reciter.id);

    final tracks = fetchedFiles.map((audioFile) {
      final surah = quranLocalDs.getSurahById(audioFile.chapterId);

      return SurahTrack(
        trackId: 'quran:${reciter.id}:${audioFile.chapterId}',
        surahId: surah.id,
        surahName: surah.nameTransliteration,
        reciterId: reciter.id,
        reciterName: reciter.name,
        url: audioFile.audioUrl,
        audioFileId: audioFile.id,
        fileSize: audioFile.fileSize,
        format: audioFile.format,
      );
    }).toList();

    await local.savePlaylistTracks(
      ReciterPlaylistTracksHive(
        reciterId: reciter.id,
        tracks: tracks.map((e) => e.toModel()).toList(),
        cachedAt: DateTime.now(),
      ),
    );

    return tracks;
  }
}
