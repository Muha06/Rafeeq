import 'package:rafeeq/features/radio_station/data/radio_remote_ds.dart';
import 'package:rafeeq/features/radio_station/domain/entities/radio_station.dart';
 import 'package:rafeeq/features/radio_station/domain/repository/radio_repository.dart';

class RadioRepositoryImpl implements RadioRepository {
  final RadioRemoteDataSource remote;

  RadioRepositoryImpl(this.remote);

  @override
  Future<List<RadioStation>> getRadioStations() async {
    final models = await remote.fetchRadioStations();

    return models.map((m) => m.toEntity()).toList();
  }

  
}
