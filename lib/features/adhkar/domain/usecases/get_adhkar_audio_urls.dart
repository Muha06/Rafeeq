import 'package:rafeeq/features/adhkar/domain/repository/repository.dart';

import '../entities/adhkar_audio_urls.dart';

class GetAdhkarAudioUrls {
  final AdhkarRepository repo;
  const GetAdhkarAudioUrls({required this.repo});

  Future<AdhkarAudioUrls> call() {
    return repo.getAdhkarAudioUrls();
  }
}
