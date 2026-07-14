import 'package:rafeeq/features/adhkar/domain/entities/adhkar_audio_urls.dart';

abstract class DhikrAudioRepository {
  Future<AdhkarAudioUrls> getAdhkarAudioUrls();
}
