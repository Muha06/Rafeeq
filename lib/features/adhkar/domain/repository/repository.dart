//abstract
import 'package:rafeeq/features/adhkar/domain/entities/adhkar_audio_urls.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';

abstract class AdhkarRepository {
  Future<List<Dhikr>> getAdhkars(String assetPath);
  Future<AdhkarAudioUrls> getAdhkarAudioUrls();
}
