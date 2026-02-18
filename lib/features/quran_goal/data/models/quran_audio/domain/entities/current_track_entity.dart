import 'package:rafeeq/features/quran_goal/data/models/quran_audio/data/models/audio_file_dto.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_audio/domain/entities/reciter_entity.dart';

class QuranTrackEntity {
  final String trackId;

  final int surahId;
  final String surahName;

  final int reciterId;
  final String reciterName;

  final String url;

  final int? audioFileId;
  final double? fileSize;
  final String? format;

  const QuranTrackEntity({
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

  factory QuranTrackEntity.build({
    required int surahId,
    required String surahName,
    required ReciterEntity reciter,
    required AudioFileDto audioFile,
  }) {
    return QuranTrackEntity(
      trackId: 'quran:${reciter.id}:$surahId',
      surahId: surahId,
      surahName: surahName,
      reciterId: reciter.id,
      reciterName: reciter.name,
      url: audioFile.audioUrl,
      audioFileId: audioFile.id,
      fileSize: audioFile.fileSize,
      format: audioFile.format,
    );
  }
}
