import 'package:rafeeq/features/quran_audio/data/models/hive/surah_track_hive.dart';

class SurahTrack {
  final String trackId;

  final int surahId;
  final String surahName;

  final int reciterId;
  final String reciterName;

  final String url;

  final int? audioFileId;
  final double? fileSize;
  final String? format;

  const SurahTrack({
    required this.trackId,
    required this.surahId,
    required this.surahName,
    required this.reciterId,
    required this.reciterName,
    required this.url,
    this.audioFileId,
    this.fileSize,
    this.format,
  });

  SurahTrackHive toModel() {
    return SurahTrackHive(
      trackId: trackId,
      surahId: surahId,
      surahName: surahName,
      reciterId: reciterId,
      reciterName: reciterName,
      url: url,
      audioFileId: audioFileId,
      fileSize: fileSize,
      format: format,
    );
  }
}
