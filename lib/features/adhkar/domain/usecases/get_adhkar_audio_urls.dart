import 'package:rafeeq/features/adhkar/domain/repository/audio_repo.dart';
import '../entities/adhkar_audio_urls.dart';

class GetAdhkarAudioUrls {
  final DhikrAudioRepository repo;
  const GetAdhkarAudioUrls({required this.repo});

  Future<AdhkarAudioUrls> call() {
    return repo.getAdhkarAudioUrls();
  }
}
