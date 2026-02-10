import 'package:rafeeq/features/adhkar/data/datasources/adhkar_local_ds.dart';
import 'package:rafeeq/features/adhkar/data/datasources/adhkar_remote_ds.dart';
import 'package:rafeeq/features/adhkar/domain/entities/adhkar_audio_urls.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/domain/repository/repository.dart';

class AdhkarRepositoryImpl implements AdhkarRepository {
  final AdhkarLocalDataSource localDs;
  final AdhkarRemoteDataSource remote;
  const AdhkarRepositoryImpl({required this.localDs, required this.remote});

  //get adhkar
  @override
  Future<List<Dhikr>> getAdhkars(String assetPath) async {
    final models = await localDs.loadAdhkarFromAsset(assetPath);

    //convert to entity
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  //get URLS from remote
  @override
  Future<AdhkarAudioUrls> getAdhkarAudioUrls() async {
    final morning = await remote.getMorningUrl();
    final evening = await remote.getEveningUrl();
    return AdhkarAudioUrls(morningUrl: morning, eveningUrl: evening);
  }
}
