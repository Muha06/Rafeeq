import 'package:rafeeq/features/quran_radio/data/radio_remote_ds.dart';
import 'package:rafeeq/features/quran_radio/domain/entities/radio_station.dart';
import 'package:rafeeq/features/quran_radio/domain/repository/radio_repository.dart';

class RadioRepositoryImpl implements RadioRepository {
  final RadioRemoteDataSource remote;

  RadioRepositoryImpl(this.remote);

  @override
  Future<List<RadioStation>> getRadioStations() async {
    final models = await remote.fetchRadioStations();

    return models.map((m) => m.toEntity()).toList();
  }
}
