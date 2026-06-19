import 'package:rafeeq/features/adhkar_02/domain/entities/adhkar_audio_urls.dart';

abstract class DhikrAudioRepository {
  Future<AdhkarAudioUrls> getAdhkarAudioUrls();
}
