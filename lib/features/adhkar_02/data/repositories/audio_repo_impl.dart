import 'package:rafeeq/features/adhkar_02/data/datasources/adhkar_audio_remote_ds.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/adhkar_audio_urls.dart';
import 'package:rafeeq/features/adhkar_02/domain/repositories/audio_repo.dart';

class DhikrAudioRepositoryImpl implements DhikrAudioRepository {
  final DhikrAudioRemoteDataSource remote;

  DhikrAudioRepositoryImpl({required this.remote});

  //get URLS from remote
  @override
  Future<AdhkarAudioUrls> getAdhkarAudioUrls() async {
    final morning = await remote.getMorningUrl();
    final evening = await remote.getEveningUrl();
    return AdhkarAudioUrls(morningUrl: morning, eveningUrl: evening);
  }
}
